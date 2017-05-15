
Author - Deepali

# KoducExpressPaypal

<a data-bindattr-12="12" href="https://badge.fury.io/rb/koduc_express_paypal">
  <img class="retina-badge" data-bindattr-13="13" src="https://badge.fury.io/rb/koduc_express_paypal.svg">
</a>

> Gem used for Paypal Express Checkout integration using NVP with both Full and Partial refunds.

### Description
KoducExpressPaypal is a simple gem used for fulfilling the requirement of one time Paypal Express Checkout integration using NVP(Name Value Pair). One can also make refunds (both full and partial) with the help of the gem. The chief principle of designing this library is the involvement of different internal Express Checkout Paypal APIs.

It is developed for the usage in Ruby on Rails web applications and integrates as a Rails plugin.

## Installation

if you're using Bundler, just add the following to your Gemfile:

```ruby
gem 'koduc_express_paypal'
```
And then execute:

    $ bundle

Or install it yourself as:

    $ gem install koduc_express_paypal

## Usage
### Payment Gateway Integration
>This simple example demonstrates how a purchase can be made using the koduc_express_paypal gem.

```ruby
# Require the gem in the controller
require 'koduc_express_paypal'	

# Declare the following API credentials in the same format in the environment files present in the config folder. Use development.rb for sandbox (test) credentials and production.rb for live credentials. The API credentials can be found from the paypal account created.

config.paypal_credentials = {
            :USER => <Username>, 
            :PWD => <Password>, 
            :SIGNATURE => <Signature>
         }

# Set the environment in the format given below. 
# Default it will be a sandbox mode.

# For Sandbox mode use
KsCheckEnvironment::ks_sandbox(true)

# For Live mode use
KsCheckEnvironment::ks_sandbox(false)

# Parameters required for payment
# payment_amount => payment amount (Integers and float values are allowed else it will throw error message)
# payment_action => type of transaction (Only alphabets are allowed)
# payment_currency => payment currency code (Only alphabets are allowed in capital letters)
# cancel_url => redirect URL for use if the customer does not authorize payment
# return_url => redirect URL for use if the customer authorizes payment

# Form a hash of the required parameters in the format given below.
# All the fields are mandatory
# Pass the parameters in string
hash = {:payment_amount =><paymentAmount>,:payment_action=><paymentAction>,:payment_currency=><paymentCurrency>,:cancel_url=><cancelURL>,:return_url=><returnURL>}

# Form an object of the class KsRequest present in KsExpressPaypal module with the hash of the parameters formed above
obj = KsExpressPaypal::KsRequest.new(hash)

# Check if the passed parameters are valid using the object formed above
validity = obj.valid?

# The format of the response obtained is {success: true/false ,response:[Error Array]}
# The value of success is true is the parameters are verified completely else it will be false.
# The value of the response will either be an Array consisting of the error messages in case the validation of the parameters fails else it will be an empty array.

# If the value of success in the above call is true call the following method with the same object formed above
set_checkout = obj.ks_set_express_checkout

# The format of the response in case of success is {success: true ,response:[Response returned from Paypal]}
# The format of the response in case of failure is {success: false ,response:[Error Message returned from Paypal]} 
# If the above call is successful the response will contain the TOKEN. 

# In case of success, using the token valued returned from above call, redirect the customer to PayPal so they can approve the transaction:

# For sandbox redirect the customer to
https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=<tokenValue>

# For LIVE redirect the customer to 
https://www.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=<tokenValue>

# The redirect presents the customer with a PayPal log-in page. After the customer logs in, PayPal displays the transaction details on the Payments Review page. The customer approves the payment on this page by clicking Continue.
# If the customer approves the payment, PayPal directs the customer to the payment confirmation page (the return URL specified above in the parameters described above). If the customer doesn't authorize the payment, PayPal directs the customer to the cancel URL, also specified in the parameters described above, and you can attempt to re-initiate the checkout.
# If the customer approves the payment, find the checkout details using the following method by passing the TOKEN obtained above with the same object.
# It is advisable to display the details on the payment confirmation page using the below method
checkout_details = KsExpressPaypal::KsRequest.ks_checkout_details(<tokenValue>)

# The format of the response in case of success is {success: true ,response:[Response returned from Paypal]}
# The format of the response in case of failure is {success: false ,response:[Error Message returned from Paypal]} 
# If the above call is successful the response will contain the TOKEN and the various other details with the PAYERID if the customer has verified the payment.
# In addition to the transaction details, your payment confirmation page should include a Confirm button. When the customer confirms the payment, call the below method to capture (collect) the payment. The following sample shows how to specify the PayerID and token value returned from the previous call. Provide the Payment Action with token and payerId.
do_checkout = KsExpressPaypal::KsRequest.ks_do_checkout(<tokenValue>,<paymentAction>,<payerId>)

# When PayPal processes the above call, it captures the payment by transferring the funds from the customer account to the appropriate merchant account and sends a confirmation e-mail to the customer.
# The format of the response in case of success is {success: true ,response:[Response returned from Paypal]}
# The format of the response in case of failure is {success: false ,response:[Error Message returned from Paypal]} 
# Refer the paypal errors in case of failure.
```
## Refund
>This simple example demonstrates how a refund can be made using the koduc_express_paypal gem.

```ruby
# Require the gem in the controller
require 'koduc_express_paypal'

# Declare the following API credentials (if not declared) in the same format in the environment files present in the config folder. Use development.rb for sandbox (test) credentials and production.rb for live credentials. The API credentials can be found from the paypal account created.

config.paypal_credentials = {
            :USER => <Username>, 
            :PWD => <Password>, 
            :SIGNATURE => <Signature>
         }
         
# Set the environment in the format given below. 
# Default it will be a sandbox mode.

# For Sandbox mode use
KsCheckEnvironment::ks_sandbox(true)

# For Live mode use
KsCheckEnvironment::ks_sandbox(false)

# Parameters for Refund
# In case of Full refund, pass only the transaction id as a parameter else the refund will be considered as partial.
# transaction_id => id of the transaction for which refund is to be made (mandatory)
# amount => amount of transaction (conditional: only required in case of partial payment)
# currency_code => payment currency code (Only alphabets are allowed in capital letters, conditional: Only required in case of partial payment.)
# note => description of the partial payment (conditional:Only required in case of partial payment.)

# Pass the parameters in string
# In case of full refund form the hash in the following format
 hash = {:transaction_id => <TransactionId>}

# In case of partial refund form the hash in the following format
 hash = {:transaction_id => <TransactionId>, :amount=><AmountToBeRefunded> , :currency_code=><PaymentCurrencyCode>,:note=><DescriptionOfThePartialPayment>}
 
# Form an object of the class KsRefund present in KsAPIRefund module with the hash of the parameters formed above
obj = KsAPIRefund::KsRefund.new(hash)

# Call the below method with the object formed above.
obj.ks_refund

# When PayPal processes the above call, it refunds the funds (either 'Full' or 'Partial') from the merchant account to the appropriate customer account.
# The format of the response in case of success is {success: true ,response:[Response returned from Paypal]}
# The format of the response in case of failure is {success: false ,response:[Error Message returned from Paypal]} 
# Refer the paypal errors in case of failure.
```

## Response format
>Success :
```
    {
        :success => true, 
        :response => [<Response return by Paypal>]
    } 
```

> Error : 
```
    {
        :success => false, 
        :response => [<Error messages separated by commas>]
    } 
```

## Important points
* In case the response is failure refer the [Paypal Errors](https://developer.paypal.com/docs/classic/api/errorcodes/) for more details.
* All the parameters should be passed in string.
