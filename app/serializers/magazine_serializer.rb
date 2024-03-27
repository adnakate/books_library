class MagazineSerializer < ActiveModel::Serializer
  attributes :id, :title, :publisher, :genre, :quantity, :eligibility_to_borrow

  def eligibility_to_borrow
    if self.object.genre == 'crime'
      scope.age < 18 ? false : true
    else
      true
    end
  end
end