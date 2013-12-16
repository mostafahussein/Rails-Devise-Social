require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Attachment do
  let(:project) { FactoryGirl.create(:project) }

  context "FactoryGirl.create" do
    it "should create fake attachment" do
      expect {
        FactoryGirl.create(:attachment, parent: project)
      }.to change{ Attachment.count }.by(1)
    end

    it "should create attachments" do
      attachment = FactoryGirl.create(:attachment, parent: project, file: File.new("#{Rails.root}/spec/resources/test.pdf"))
      attachment.file_name.should == "test.pdf"
      attachment.attach_type.should == "application/pdf"
      attachment.attach_size.should == 217725
      attachment = FactoryGirl.create(:attachment, parent: project, file: File.new("#{Rails.root}/spec/resources/test.docx"))
      attachment.file_name.should == "test.docx"
      attachment.attach_type.should == "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
      attachment.attach_size.should == 4749
      attachment = FactoryGirl.create(:attachment, parent: project, file: File.new("#{Rails.root}/spec/resources/old-lady.png"))
      attachment.file_name.should == "old-lady.png"
      attachment.attach_type.should == "image/png"
      attachment.attach_size.should == 126592
    end
  end

end