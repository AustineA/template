require 'httparty'


class SubscriptionsController < ApplicationController
  # include HTTParty

  def subscriber
    transaction = Transaction.find_by_ref_no(params[:id])
    plan = transaction.transaction_for
    amount = transaction.amount

		case 
      when plan == "CLASSIC"
        classic transaction
			when plan == "PRO"
        pro transaction
      when plan == "CUSTOM"
        custom transaction
			else
				render "Unknown plan"		
		end


  end



  private

  def classic transaction
    ref_no = transaction.ref_no
    price = 5000
    duration = transaction.duration
    due_amount = price * duration
    user = transaction.user
   
    if verify_transaction due_amount, ref_no
      subscription = user.build_subscription(plan: transaction.transaction_for, amount: due_amount, expiring_date: Time.now + 30.day, start_date: Time.now, boost: 10, priorities: 15, max_post: 1000)
      if subscription.save
        render json: { status: "subscription created"}
        transaction.update_attributes(status: "PAID")
      end
    else
      render json: { status: "unsuccessful", message: "Can not verify payment" }, status: :unprocessable_entity
    end
  end

  def pro transaction
    ref_no = transaction.ref_no
    price = 12500
    duration = transaction.duration
    due_amount = price * duration
    user = transaction.user
   
    if verify_transaction due_amount, ref_no
      subscription = user.build_subscription(plan: transaction.transaction_for, amount: due_amount, expiring_date: Time.now + 30.day, start_date: Time.now, boost: 20, priorities: 40, max_post: 1000)
      if subscription.save
        render json: { status: "subscription created"}
        transaction.update_attributes(status: "PAID")
      end
    else
      render json: { status: "unsuccessful", message: "Can not verify payment" }, status: :unprocessable_entity
    end
  end

  def custom transaction
    ref_no = transaction.ref_no
    price = 20000
    duration = transaction.duration
    due_amount = price * duration
    user = transaction.user
   
    if verify_transaction due_amount, ref_no
      subscription = user.build_subscription(plan: transaction.transaction_for, amount: due_amount, expiring_date: Time.now + 30.day, start_date: Time.now, boost: 30, priorities: 60, max_post: 1000)
      if subscription.save
        render json: { status: "subscription created"}
        transaction.update_attributes(status: "PAID")
      end
    else
      render json: { status: "unsuccessful", message: "Can not verify payment" }, status: :unprocessable_entity
    end
  end


  def verify_transaction due_amount, ref_no

    response = HTTParty.get("https://api.paystack.co/transaction/verify/#{ref_no}", 
                  headers: { "Authorization"=> "Bearer #{Rails.application.credentials.dig(:paystack, :secret_key)}",
                  "content-type" => "application/json"})

                  # render json: response['data']['amount']
    paid = response['data']['amount']/100
    status = response['data']['status']
    if paid == due_amount && status == 'success'
      return true
    end
  end
end
