
Author - Deepali

# KoducStripe

KoducStripe is a lightweight wrapper for Stripe payments API. This ruby gem provides a platform to integrate Stripe payment gateway in Ruby on Rails Application.

>Currently KoducStripe supports One-time Payment with partially or completely Refund payment with Stripe.

It is developed for the usage in Ruby on Rails web applications and integrates as a Rails plugin.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'koduc_stripe'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install koduc_stripe

# Usage

Provide the Stripe API Key while initializing the Rails Application by placing the key under `config/initializer`.

Create a new file in initializer, say `koduc_stripe.rb` and write below piece of code there.
```ruby
KsStripe::Client.configure do |config|
  config.stripe_api_key = STRIPE_API_KEY
end
```
** Do not forget to restart the rails server after adding Stripe API Key.


## Charge a user
To charge a user, first create an object of `KsStripe::KsBase` class by supplying a hash containing card details. Hash should have below keys:
* ``` card_number  => Card Number to charged (Required) ```
* ``` cvc          => Card Verification Code of the card (Required)```
* ``` exp_month    => Expiration month of the Card (Required)```
* ``` exp_year     => Expiration Year of the Card (Required)```
* ``` name         => Name on the Card (Optional)```
* ``` card_type    => Type of the credit card (Optional)```

For example:
```ruby
card_obj = KsStripe::KsBase.new(
          :card_number=>'4242424242424242',
          :cvc=>'123',
          :exp_month => '01',
          :exp_year => '2020',
          :card_type => 'visa',
          :name=>"Atul Khanduri"
          )
```

Secondly, charge the user by calling `charge method` from `KsStripe::KsBase` object with amount to be charged and optional description of the payment as parameters.

For example:
```ruby
charge = card_obj.charge(10, "This is a test payment by KsStripe Gem")
```

##### Please Note:
* Amount to be charge must be in cents and supports only US Dollars.
* Amount should be a positive integer as Stripe does not supports amount in decimals.
* If card_type is provided then only Card is Validated using Regular expression. Although other algorithm's are always applied to validate card number.
* Credit Card type can only be american_express, mastercard, visa, jcb, diners_club or discover as Stripe supports only these type of cards.


#### Response of One Time Payment Charge:
If the Charge is successful then the response will be the response returned by Stripe.

If there's any validation or any other error in the payment, then all the errors are returned in below format:
```ruby
{
  "error" => {
    "message" => [<All the Error Messages in Array>]
  }
}
```

### Refund a Payment

To refund a one-time payment, call `KsStripe::KsBase.refund` method with parameters as charge id, optional amount(in cents) to be refund and optional reason of the refund.
```ruby
KsStripe::KsBase.refund(<charge_id>, <amount>, <reason>)
```

##### Please Note:
* Amount to be charge must be in cents and supports only US Dollars.
* Complete payment is refunded if amount is not provided in the parameter else partially amount is refunded as provided in the parameter.
* Amount must not be greater than the charge amount.
* Refund reason must be one of duplicate, fraudulent or requested_by_customer

#### Response of Refund:
If the refund is successful then the response will be the response returned by Stripe.

If there's any validation or any other error in payment refund, then all the errors are returned in below format:
```ruby
{
  "error" => {
    "message" => [<All the Error Messages in Array>]
  }
}
```
