class UsersController < ApplicationController
  def share
    u = User.where(ref: params[:ref]).first
                            #return render status: 404, text: "Reference user not found" if !u
    return render_404 unless u
    u.points += 1
    u.save
    return redirect_to 'https://play.google.com/store/apps/details?id=com.cooltaxi.users'
  end
  def register
    #error, if device_id not matches regular expression rule
    return render json: {errors: "Bad device id"}, status: 400 if params[:device_id] !~ /./
    
    #this is line that makes you love ruby on rails, hope it's readable:
    # find user with device_id
    # if not found, create new object with device_id and ref set to md5(device_id:current_time)

    u = User.where(device_id: params[:device_id]).first_or_initialize(ref: Digest::MD5.hexdigest("#{params[:device_id]}:#{Time.now.to_f}"))
    u.email = params[:email] if params[:email] =~ /.@.+\..+/ #TODO: stronger email validation
    u.phone = params[:phone]
    u.save                 #will create new or update existing
    return render json: {id: u.id, ref: u.ref}
  end
  def order
    u=User.find(params[:user_id])                                #where(id: params[:id]).first #Check that the user exists with this id
                                                                 #return render_404 unless u
    return render json: {errors: "Yu driver"} if driver=u.driver # check that the order is not the driver draws
                                                                 #return render json: {errors: "rtyui"} if u
    o=Order.where(user_id: u.device_id).first_or_initialize
                                                                #return render json: {error: "Order with the id exists "} if o
    o.user_id=u.device_id
    o.address= params[:address]
    o.gps_long_user= params[:gps_long_user]
    o.gps_lat_user= params[:gps_lat_user]
    if u.points > 0
      u.points-=1
    end
    u.save
    o.save
    return render json: {id: o.id }
                                     #return redirect_to 'https://play.google.com/store/apps/details?id=com.cooltaxi.users'
  end
  def status
    u=User.find(params[:user_id])              #where(id: params[:id]).first #Check that the user exists with this id
                                               #return render json: {errors: "Order with this id does not exist"} if !o=u.orders
    order=u.order
    return render json: {errors: "Order ID and user ID do not match"} if !order
    o=Order.find(params[:order_id])
    d=o.driver
    return render json: {errors: "Order this id is not accepted"} if !d
    return render json: {name: d.name, gps_long_drivers: o.gps_long_drivers, gps_lat_drivers: o.gps_lat_drivers,cancellations: o.cancellations}    end
  def cancel
    u=User.find(params[:user_id])
    o=Order.find(params[:order_id])
    if u.id == o.user_id
      o.destroy
      return render json: {text: "the order destroy"} if order=u.order
    end
  end
  def point
    u=User.find(params[:user_id])
    return render json: {id: u.id, points: u.points}
  end
end