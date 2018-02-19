require 'test_helper'

class QuotationMailerTest < ActionMailer::TestCase
  test "quotation_rejected" do
    mail = QuotationMailer.quotation_rejected
    assert_equal "Quotation rejected", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
