require 'test_helper'

class AuditTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
  end

  test 'creates audit for election' do
    election = Election.new(name: 'Test', start_at: Time.now, end_at: Time.now, user: @user, settings: { visibility: :public })
    assert_difference('Audit.count') do
      election.save
    end

    audit = Audit.last

    assert_equal 'Election', audit.auditable_type
    assert_equal election.id, audit.auditable_id
    assert_equal @user.id, audit.user_id
    assert audit.audit_changes
    assert_equal 'create', audit.audit_type
  end
end
