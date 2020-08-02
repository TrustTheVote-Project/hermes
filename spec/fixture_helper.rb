def read_fixture(file_name)
    require "json"
    file = File.open "spec/fixtures/files/#{file_name}.json"
    File.read file
end