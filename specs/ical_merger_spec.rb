require 'lib/ical_merger'
require 'specs/spec_helper'

describe ICalMerger do

  # Example ical URL for Google calendar
  # http://www.google.com/calendar/ical/YOUR_UNIQUE_CALENDAR_TOKEN.calendar.google.com/public/basic.ics"
  
  before(:all) do
    @ical_urls = ["specs/fixtures/test1.ics", "specs/fixtures/test2.ics"]

    @today = DateTime.new(y=2010,m=4,d=13, h=14,min=30,s=12)
    DateTime.stub!(:now).and_return(@today)

    @output_dir = 'specs/output'
    reset_output_dir(@output_dir)
  end


  it "should construct a new aggregator containing all icalendars from urls provided" do
    ical_aggr = ICalMerger.new(@ical_urls)
    ical_aggr.instance_variable_get(:@icalendars).length.should == 2
  end


  it "should contain a combined calendar of events which end after today's date" do
    ical_aggr = ICalMerger.new(@ical_urls)
    
    ical_aggr.combined_calendar.events.length.should == 5
    
  end
  
  it "should display multiday conferences that have a start date before today but an end date after today" do
   
    ical_aggr = ICalMerger.new(@ical_urls)
    ical_aggr.to_s.should include "Code Jambouree"    
       
  end
  
  
  it "should write the upcoming combined events to a new ics file" do
    actual_output_filepath = "#{@output_dir}/combined.ics"

    ical_aggr = ICalMerger.new(@ical_urls)
    ical_aggr.write_combined_events_to_file(actual_output_filepath)

    # Note: Written out file contains DOS line endings.
    # Hence need to convert to UNIX on reading
    actual = File.read(actual_output_filepath).gsub("\r\n", "\n")
    
    actual.should == @@expected_ics_content
    
  end
  
  
  it "should display a calender" do   
    
    ical_aggr = ICalMerger.new(@ical_urls)
    ical_aggr.to_s.should == @@calendar_expected
    
  end
  
end



### TEST DATA ###

@@expected_ics_content =<<EOF
BEGIN:VCALENDAR
CALSCALE:GREGORIAN
PRODID:iCalendar-Ruby
VERSION:2.0
BEGIN:VEVENT
CREATED:20100409T100033Z
DESCRIPTION:Get your coding hats on we're getting all geeked up!
DTEND:20500430T170000Z
DTSTAMP:20100410T204821Z
DTSTART:20100407T070000Z
LAST-MODIFIED:20100409T140547Z
LOCATION:The Gaterfront Louth
SEQUENCE:2
STATUS:CONFIRMED
SUMMARY:Code Jambouree
TRANSP:OPAQUE
UID:abcdecfhijklmnopqrstuvwxyz@google.com
END:VEVENT
BEGIN:VEVENT
CREATED:20100409T084431Z
DESCRIPTION:This week talking about inspirational geeks.
DTEND;VALUE=DATE:20100415
DTSTAMP:20100413T091541Z
DTSTART;VALUE=DATE:20100414
LAST-MODIFIED:20100413T091529Z
LOCATION:Splash Bar\\, Grand Canal Dock
SEQUENCE:4
STATUS:CONFIRMED
SUMMARY:Geeks Aloud
TRANSP:TRANSPARENT
UID:abcdecfhijklmnopqrstuvwxyz@google.com
END:VEVENT
BEGIN:VEVENT
CREATED:20100409T083800Z
DESCRIPTION:
DTEND:20100504T200000Z
DTSTAMP:20100410T210044Z
DTSTART:20100504T180000Z
LAST-MODIFIED:20100409T084028Z
LOCATION:The Hop on Pearse St
SEQUENCE:2
STATUS:CONFIRMED
SUMMARY:Geek Gaggle
TRANSP:TRANSPARENT
UID:abcdecfhijklmnopqrstuvwxyz@google.com
END:VEVENT
BEGIN:VEVENT
CREATED:20100407T200744Z
DESCRIPTION:A meet and code for all developers in any language
DTEND;VALUE=DATE:20100510
DTSTAMP:20100410T210044Z
DTSTART;VALUE=DATE:20100508
LAST-MODIFIED:20100409T084403Z
LOCATION:Rons Halfway House\\, Thomas St\\, Dublin 8
SEQUENCE:0
STATUS:CONFIRMED
SUMMARY:Coder Conference
TRANSP:TRANSPARENT
UID:abcdecfhijklmnopqrstuvwxyz@google.com
END:VEVENT
BEGIN:VEVENT
CREATED:20100409T100617Z
DESCRIPTION:sip a cider while discussing sql puns 
DTEND:20100525T213000Z
DTSTAMP:20100410T204821Z
DTSTART:20100525T180000Z
LAST-MODIFIED:20100409T104355Z
LOCATION:Dressa Bar
SEQUENCE:4
STATUS:CONFIRMED
SUMMARY:Cider with Sql
TRANSP:OPAQUE
UID:abcdecfhijklmnopqrstuvwxyz@google.com
END:VEVENT
END:VCALENDAR
EOF

@@calendar_expected =<<EOF
April 07, 2010 07:00 AM:	Code Jambouree
The Gaterfront Louth
Get your coding hats on we're getting all geeked up!
April 14, 2010 12:00 AM:	Geeks Aloud
Splash Bar, Grand Canal Dock
This week talking about inspirational geeks.
May 04, 2010 06:00 PM:	Geek Gaggle
The Hop on Pearse St

May 08, 2010 12:00 AM:	Coder Conference
Rons Halfway House, Thomas St, Dublin 8
A meet and code for all developers in any language
May 25, 2010 06:00 PM:	Cider with Sql
Dressa Bar
sip a cider while discussing sql puns 
EOF