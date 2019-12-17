require 'test_helper'

class AuditTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    User.current_user = @user
    @election = Election.new(name: 'Test', start_at: Time.now, end_at: Time.now, user: @user, settings: { visibility: :public })
  end

  test 'creates audit when creating an entity' do
    assert_difference('Audit.count') do
      @election.save
    end

    audit = Audit.last

    assert_equal 'Election', audit.auditable_type
    assert_equal @election.id, audit.auditable_id
    assert_equal @user.id, audit.user_id
    assert_equal 'create', audit.audit_type
    assert_equal({}, audit.audit_changes)
  end

  test 'creates audit when updating an entity' do
    @election.save
    @election.name = 'Changed'

    assert_difference('Audit.count') do
      @election.save
    end

    audit = Audit.last

    assert_equal 'Election', audit.auditable_type
    assert_equal @election.id, audit.auditable_id
    assert_equal @user.id, audit.user_id
    assert_equal 'update', audit.audit_type
    assert_equal({'name' => ['Test', 'Changed']}, audit.audit_changes)
  end

  test 'creates audit when deleting an entity' do
    @election.save

    assert_difference('Audit.count') do
      @election.destroy
    end

    audit = Audit.last

    assert_equal 'Election', audit.auditable_type
    assert_equal @election.id, audit.auditable_id
    assert_equal @user.id, audit.user_id
    assert_equal 'destroy', audit.audit_type
    assert_equal({}, audit.audit_changes)
  end


  test 'only create audit if something changed' do
    @election.save

    assert_difference('Audit.count', 0) do
      @election.touch
    end
  end

  test 'skip created_at and updated_at on audits' do
    @election.save
    @election.name = 'Changed'
    @election.save

    audit = Audit.last

    assert_equal 'Election', audit.auditable_type
    assert_equal @election.id, audit.auditable_id
    assert_equal @user.id, audit.user_id
    assert_equal({'name' => ['Test', 'Changed']}, audit.audit_changes)
    assert_equal 'update', audit.audit_type
  end
end
