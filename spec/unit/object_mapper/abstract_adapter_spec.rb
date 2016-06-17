require 'rails_helper'

describe ActiveAdmin::ObjectMapper::AbstractAdapter do

  module ActiveAdmin::ObjectMapper::KnownOrm; class SimpleAdapter < ActiveAdmin::ObjectMapper::AbstractAdapter; end; end

  let(:simple_adapter_class) { ActiveAdmin::ObjectMapper::KnownOrm::SimpleAdapter }

  subject { ActiveAdmin::ObjectMapper::AbstractAdapter }

  describe ".register" do
    let(:adapter) { double }

    after do
      subject.adapters.delete(adapter)
    end

    it "registers an Adapter" do
      subject.register adapter
      expect(subject.adapters).to include(adapter)
    end
  end

  describe ".for" do
    context "When adapter is not found" do
      it "rises a NoAdapterFound error" do
        expect {
          subject.for("unknown_orm", "simple", nil)
        }.to raise_error ActiveAdmin::NoAdapterFound
      end
    end

    context "When adapter is not registered" do
      module ActiveAdmin::ObjectMapper::KnownOrm; class NotAdapter; end; end

      it "rises a NoAdapterFound error" do
        expect {
          subject.for("known_orm", "not_adapter", nil)
        }.to raise_error ActiveAdmin::NoAdapterFound
      end
    end

    context "When adapter is registered" do
      it "returns adapter" do
        expect(subject.for("known_orm", "simple", nil)).to be_a(simple_adapter_class)
      end
    end
  end

  context "Adapter" do
    let(:base_object) { double }
    let(:simple_adapter) { subject.for("known_orm", "simple", base_object) }

    it "delegates method calls to base object" do
      expect(base_object).to receive(:method_of_object)
      simple_adapter.method_of_object
    end
  end

end
