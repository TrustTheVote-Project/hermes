require 'rails_helper'
require 'swagger_helper'

describe 'Voters API' do

  path '/voters/import' do

    post 'imprtorts a list of voters' do
      tags 'Voters'
      description 'Imports a list of voters.'
      consumes 'text/csv'
      parameter name: :file, in: :body, value: "first_name,last_name,address,city,zip,state,birth_date\nRon,Tsosie,1299 Taylor St,Montgomery,36109,AL,1963-09-28\nBrandie,Nguyen,9015 Fairview St,Wasilla,99654,AK,1946-12-11"

      response '204', 'no content' do
        let(:file) { fixture_file_upload('files/sampe_voters_import.csv', 'text/csv') }
        run_test!
      end
    end
  end
end
