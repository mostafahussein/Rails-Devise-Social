require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Message do
  let(:sender) { FactoryGirl.create(:user) }
  let(:recipient) { FactoryGirl.create(:user) }

  context "FactoryGirl.create" do
    it "should create fake message" do
      expect {
        FactoryGirl.create(:message, sender: sender, recipient: recipient)
      }.to change{ Message.count }.by(1)
    end

    it "should create fake message with attachment" do
      message = FactoryGirl.create(:message, sender: sender, recipient: recipient)
      message.attachments << FactoryGirl.create(:attachment)
      Message.should have(1).record
      message.attachments.size.should == 1
      message.attachments << FactoryGirl.create(:attachment, file: File.new("#{Rails.root}/spec/resources/test.pdf"))
      message.attachments.size.should == 2
    end
  end

end