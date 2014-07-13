require 'spec_helper'

describe Wow::ToonsController, type: :routing do
  describe 'routing' do
    it { expect(get    '/wow/toons'            ).to route_to('wow/toons#index') }
    it { expect(get    '/wow/toons/new'        ).to route_to('wow/toons#new') }
    it { expect(get    '/wow/toons/1'          ).to route_to('wow/toons#show', :id => '1') }
    it { expect(get    '/wow/toons/1/edit'     ).to route_to('wow/toons#edit', :id => '1') }
    it { expect(post   '/wow/toons'            ).to route_to('wow/toons#create') }
    it { expect(put    '/wow/toons/1'          ).to route_to('wow/toons#update', :id => '1') }
    it { expect(delete '/wow/toons/1'          ).to route_to('wow/toons#destroy', :id => '1') }
  end
end
