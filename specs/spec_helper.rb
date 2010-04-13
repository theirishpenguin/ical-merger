require 'fileutils'


def reset_output_dir(output_dir)
    FileUtils.rm_rf(output_dir) # Warning: This blows away your output dir!
    FileUtils.mkdir_p(output_dir)
end


def write_out_comparision_files(expected, actual)

    output_dir = 'specs/output'

    reset_output_dir(output_dir)

    File.open("#{output_dir}/expected.txt", 'w') do |f|
       f.write expected
    end

    File.open("#{output_dir}/actual.txt", 'w') do |f|
       f.write actual
    end

    puts ' meld specs/output/expected.txt specs/output/actual.txt '
end
