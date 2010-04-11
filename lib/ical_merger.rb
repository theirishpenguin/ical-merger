require 'rubygems'
require 'icalendar'
require 'date'
require 'open-uri'

class ICalMerger
  include Icalendar
  

  def initialize(ical_urls)

    @icalendars = []

    ical_urls.each do |ical_url|

      # Each ical url can contain many calendars
      icals = Icalendar.parse(open(ical_url).read)

      icals.each do |ical_calendar|
         @icalendars << ical_calendar
      end

    end

  rescue *HTTP_ERRORS => error
    handle_error(error)
  end


  def combined_calendar
    return @combined if @combined

    @combined = Calendar.new

    @icalendars.each do |ical_calendar|
      @combined.events += ical_calendar.events
    end

    @combined.events.reject! { |event| event.dtend < DateTime.now }
    @combined.events = @combined.events.sort_by { |event| event.dtstart }

    @combined
  end
  
  def to_s
    output = ''

    combined_calendar.events.each do |event|
      output << "#{event.dtstart.strftime("%B %d, %Y %I:%M %p")}:\t"
      output << "#{event.summary}\n"
      output << "#{event.location}\n"
      output << "#{event.description}\n"
    end

    output
  end


  def write_combined_events_to_file
    File.open("combined.ics", "w+") {|f| f.write(combined_calendar.to_ical)}
  end 
  
  
  private

  def handle_error(error)
    # Implement this if desired...
  end

end