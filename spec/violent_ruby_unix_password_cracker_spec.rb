require "spec_helper"

module ViolentRuby
  describe UnixPasswordCracker do
    context '#new' do
      before(:each) { @cracker = UnixPasswordCracker.new } 

      it 'defaults to not having a /etc/passwd file' do
        expect(@cracker.file).to be(false)  
      end

      it 'defaults to not have a dictionary file' do
        expect(@cracker.dictionary).to be(false)  
      end  

      it 'can set an /etc/passwd file' do
        file = "One good thing about music, when it hits you, you feel no pain."
        @cracker.file = file
        expect(@cracker.file).to be(file)  
      end  

      it 'can set a dictionary file' do
        dictionary = "None but ourselves can free our minds."
        @cracker.dictionary = dictionary
        expect(@cracker.dictionary).to be(dictionary)  
      end  
    end
  end
end

