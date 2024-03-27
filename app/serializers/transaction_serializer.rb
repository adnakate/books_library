class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :borrowed_at, :returned_at, :book, :magazine

  def book
    if self.object.book_id.present?
      ActiveModelSerializers::SerializableResource.new(self.object.book, serializer: UserBookSerializer)
    end
  end

  def magazine
    if self.object.magazine_id.present?
      ActiveModelSerializers::SerializableResource.new(self.object.magazine, serializer: UserMagazineSerializer)
    end
  end
end