require 'rails_helper'
require 'swagger_helper'

describe 'Voters API' do

  path '/voters/import' do

    put 'imprtorts a list of voters' do
      tags 'Voters'
      description 'Imports a list of voters from a csv file. <br/><br/> Example csv file: <br>
                  <table class="table table-bordered table-hover table-condensed">
                  <thead><tr><th title="Field #1">first_name</th><th title="Field #2">last_name</th><th title="Field #3">address</th><th title="Field #4">city</th><th title="Field #5">zip</th><th title="Field #6">state</th><th title="Field #7">birth_date</th><th title="Field #8">id</th></tr></thead>
                  <tbody><tr><td>Ron</td><td>Tsosie</td><td>1299 Taylor St</td><td>Montgomery</td><td align="right">36109</td><td>AL</td><td>1963-09-28</td><td align="right">1</td></tr>
                  <tr><td>Brandie</td><td>Nguyen</td><td>9015 Fairview St</td><td>Wasilla</td><td align="right">99654</td><td>AK</td><td>1946-12-11</td><td align="right">2</td></tr>
                  <tr><td>Peggy</td><td>Lee</td><td>5737 Homestead Rd</td><td>Tucson</td><td align="right">85718</td><td>AZ</td><td>1993-11-26</td><td align="right">3</td></tr></tbody></table>'
      consumes 'application/octet-stream'
      parameter name: :file, type: :file,  description: "the csv of voter data"

      response '204', 'no content' do
        let(:file) { fixture_file_upload('files/sampe_voters_import.csv', 'text/csv') }
        run_test!
      end
    end
  end
end