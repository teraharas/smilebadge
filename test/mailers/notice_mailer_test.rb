require 'test_helper'

class NoticeMailerTest < ActionMailer::TestCase
  test "hello" do
    mail = NoticeMailer.hello
    assert_equal "Hello", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
