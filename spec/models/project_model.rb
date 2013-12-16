require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Project do
  context "FactoryGirl.create" do
    it "should create fake project" do
      expect {
        FactoryGirl.create(:project)
      }.to change{ Project.count }.by(1)
    end

    it "should create fake project with attachment" do
      project = FactoryGirl.create(:project)
      project.attachments << FactoryGirl.create(:attachment)
      Project.should have(1).record
      project.attachments.size.should == 1
      project.attachments << FactoryGirl.create(:attachment, file: File.new("#{Rails.root}/spec/resources/test.pdf"))
      project.attachments.size.should == 2
    end
  end

end