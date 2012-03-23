require_relative '../../../spec_helper'

describe Arachni::Parser::Element::Cookie do
    before( :all ) do
        @url = server_url_for( :cookie )
        @raw = { 'mycookie' => 'myvalue' }
        @c = Arachni::Parser::Element::Cookie.new( @url, @raw )
        @http = Arachni::HTTP.instance
    end

    describe :submit do
        it 'should perform the appropriate HTTP request with appropriate params' do
            body_should = @c.auditable.map { |k, v| k.to_s + v.to_s }.join( "\n" )
            body = nil
            @c.submit.on_complete {
                |res|
                body = res.body
            }
            @http.run
            body_should.should == body
        end
    end

    context 'when initialized' do
        context 'with hash key/pair' do
            describe :simple do
                it 'should return name/val as a key/pair' do
                    raw = { 'name' => 'val' }
                    c = Arachni::Parser::Element::Cookie.new( @url, raw )
                    c.simple.should == raw
                end
            end
        end
        context 'with attributes' do
            describe :simple do
                it 'should return name/val as a key/pair' do
                    raw = { 'name' => 'myname', 'value' => 'myvalue' }
                    c = Arachni::Parser::Element::Cookie.new( @url, raw )
                    c.simple.should == { raw['name'] => raw['value'] }
                end
            end
        end
    end

    describe :type do
        it 'should be "cookie"' do
            @c.type.should == 'cookie'
        end
    end

    describe :secure? do
        context 'when set' do
            it 'should be return true' do
                cookie = Arachni::Parser::Element::Cookie.new( @url,
                    'name'   => 'mycookie',
                    'value'  => 'myvalue',
                    'secure' => true
                )
                cookie.secure?.should be_true
            end
        end

        context 'when not set' do
            it 'should be return false' do
                @c.secure?.should be_false
            end
        end
    end

    describe :httponly? do
        context 'when set' do
            it 'should be return true' do
                cookie = Arachni::Parser::Element::Cookie.new( @url,
                    'name'   => 'mycookie',
                    'value'  => 'myvalue',
                    'httponly' => true
                )
                cookie.http_only?.should be_true
            end
        end

        context 'when not set' do
            it 'should be return false' do
                @c.http_only?.should be_false
            end
        end
    end

end
