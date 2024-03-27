RSpec.shared_examples 'creates a new object' do |klass|
  it "increments the number of #{klass.name}s by 1" do
    expect { perform }.to change { klass.count }.by(1)
  end

  it 'returns a created response' do perform
    expect(perform).to eq 201
  end
end