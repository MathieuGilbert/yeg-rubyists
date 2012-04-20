class MemberJob < Struct.new(:avatar_type, :member)
  def perform
    Member.create_member_avatar(avatar_type, member)
  end
end