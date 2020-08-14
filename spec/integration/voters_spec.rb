require 'rails_helper'
require 'swagger_helper'

describe 'Voters API' do

  path '/voters/import' do

    put 'imprtorts a list of voters' do
      tags 'Voters'
      description 'Imports a list of voters from a csv file. <br/><br/> Example csv file: <br>
                  <table class="table table-bordered table-hover table-condensed">
                  <thead><tr><th>first_name</th><th>middle_name</th><th>last_name</th><th>address</th><th>city</th><th>zip</th><th>state</th><th>birth_date</th><th>id</th></tr></thead>
                  <tbody><tr><td>Ron</td><td>Louis</td><td>Tsosie</td><td>1299 Taylor St</td><td>Montgomery</td><td align="right">36109</td><td>AL</td><td>1963-09-28</td><td align="right">1</td></tr>
                  <tr><td>Brandie</td><td></td><td>Nguyen</td><td>9015 Fairview St</td><td>Wasilla</td><td align="right">99654</td><td>AK</td><td>1946-12-11</td><td align="right">2</td></tr>
                  <tr><td>Peggy</td><td>R.</td><td>Lee</td><td>5737 Homestead Rd</td><td>Tucson</td><td align="right">85718</td><td>AZ</td><td>1993-11-26</td><td align="right">3</td></tr></tbody></table>'
      consumes 'application/octet-stream'
      parameter name: :file, type: :file,  description: "the csv of voter data"
      parameter({
        :in => :header,
        :type => :string,
        :name => :Authorization,
        :required => true,
        :description => 'Client token'
      })

      response '204', 'no content' do
        let(:file) { fixture_file_upload('files/sampe_voters_import.csv', 'text/csv') }
        let(:Authorization) { 'Bearer ' + User.create({token: "token"}).token }
        before do
          allow(ProviderClient).to receive(:register_voters).and_return(nil)
        end


        run_test!
      end
    end
  end

  path '/voters' do
    get 'Retrieves the full list of voters' do
      tags 'Voters'
      produces 'application/json'
      parameter({
        :in => :header,
        :type => :string,
        :name => :Authorization,
        :required => true,
        :description => 'Client token'
      })

      response '200', 'list voters' do
        schema type: 'array', items: { '$ref' => '#/definitions/voter' }
        let(:Authorization) { 'Bearer ' + User.create({token: "token"}).token }
        run_test!
      end
    end
  end

  path '/voters/{id}' do
    get 'Retrieves the specified voter' do
      tags 'Voters'
      produces 'application/json'
      parameter({
        :in => :header,
        :type => :string,
        :name => :Authorization,
        :required => true,
        :description => 'Client token'
      })
      parameter(:name => :id, :in => :path, :type => :string)

      response '200', 'voter record' do
        schema '$ref' => '#/definitions/voter'
        let(:Authorization) { 'Bearer ' + User.create({token: "token"}).token }
        let(:id) {Voter.create().id}

        run_test!
      end
    end
  end
end
