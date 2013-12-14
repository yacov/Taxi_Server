class DriversController < ApplicationController
  def share
    u=User.where(ref: params[:ref]).first
    return render status: 404, text: "Reference user not found" if !u
    u.points+=1
    u.save
    return redirect_to 'https://play.google.com/store/apps/details?id=com.cooltaxi.users'
  end
  def register
    #error, if device_id not matches regular expression rule
    return render json: {errors: "Bad device id"}, status: 400 if params[:device_id] !~ /./
    #this is line that makes you love ruby on rails, hope it's readable:
    # find user with device_id
    # if not found, create new object with device_id and ref set to md5(device_id:current_time)
    u =User.where(device_id: params[:device_id]).first_or_initialize(ref: Digest::MD5.hexdigest("#{params[:device_id]}:#{Time.now.to_f}"))
    u.phone= params[:phone]
    u.email= params[:email] if params[:email] =~ /.@.+\..+/ #TODO: stronger email validation
    d=Driver.where(:user_id => params[:device_id]).first_or_initialize
    #d.user=u.driver
    d.user_id = u.device_id
    d.name= params[:name]
    d.car_id= params[:car_id]
    d.brand= params[:brand]
    u.save
    d.save
    return render json: {id: u.id, ref: u.ref }
  end
  def point
    u=User.find(params[:driver_id])
    d=u.driver
    return render json: {errors: "You are not a driver"} if d
    return render json: {id: u.id, points: u.points}
  end
  def order
    u=User.find(params[:driver_id])
    return render json: {errors: "Yu nat driver"} if !d=u.driver
    gps_long_drivers = params[:gps_long_driver]
    gps_lat_drivers = params[:gps_lat_driver]

    #result= Order.find_by_sql"SELECT id, name,6371 * 2 * ASIN(SQRT(POWER(SIN(RADIANS(order.gps_lat_user - ABS(@gps_lat_drivers))), 2) + COS(RADIANS(order.gps_lat_user)) * COS(RADIANS(ABS(@gps_lat_drivers))) * POWER(SIN(RADIANS(order.gps_long_user - @gps_long_drivers)), 2))) AS distance
    #        FROM order HAVING distance < 10 ORDER BY distance LIMIT 10; "
    #sql = ActiveRecord::Base.connection();
    #sql.execute"SET "
    #ar.each do |result|
    #end

    #Order.find_by_sql"SELECT ((ACOS(SIN(#{self.gps_lat_drivers} * PI() / 180) * SIN(`gps_lat_user` * PI() / 180) + COS(#{self.gps_lat_drivers} * PI() / 180) * COS(`gps_lat_user` * PI() / 180) * COS((#{self.gps_long_drivers} – `gps_long_user`) * PI() / 180)) * 180 / PI()) * 60 * 1.1515) AS distance FROM `orders` HAVING distance <= `5` ORDER BY distance ASC"
    #result=Order.where("((Math.acos(Math.sin(#{self.gps_lat_drivers} * Math.pi() / 180) * Math.sin(`gps_lat_user` * Math.pi() / 180) + Math.cos(#{self.gps_lat_drivers} * Math.pi() / 180) * Math.cos(`gps_lat_user` * Math.pi() / 180) * Math.cos((#{self.gps_long_drivers} – `gps_long_user`) * Math.pi() / 180)) * 180 / Math.pi()) * 60 * 1.1515)and status=1").order("((Math.acos(Math.sin(#{self.gps_lat_drivers} * Math.pi() / 180) * Math.sin(`gps_lat_user` * Math.pi() / 180) + Math.cos(#{self.gps_lat_drivers} * Math.pi() / 180) * Math.cos(`gps_lat_user` * Math.pi() / 180) * Math.cos((#{self.gps_long_drivers} – `gps_long_user`) * Math.pi() / 180)) * 180 / Math.pi()) * 60 * 1.1515) ").limit(10).all
    #result = Order.find_by_sql (" SELECT id, ((ACOS(SIN(#{self.gps_lat_drivers} * PI() / 180) * SIN(`gps_lat_user` * PI() / 180) + COS(#{self.gps_lat_drivers} * PI() / 180) * COS(`gps_lat_user` * PI() / 180) * COS((#{self.gps_long_drivers} – `gps_long_user`) * PI() / 180)) * 180 / PI()) * 60 * 1.1515) AS distance FROM 'order'") #HAVING distance <= `5` ORDER BY distance ASC")
    result=Order.find_by_sql"SELECT * FROM Places WHERE (gps_lat_drivers - :gps_lat_user)^2 + (gps_long_drivers - :gps_long_user)^2 <= :Distance^2"
    #result=Order.where("((Math.acos(Math.sin(#{params[:gps_lat_drivers]} * Math.pi() / 180) * Math.sin(`gps_lat_user` * Math.pi() / 180) + Math.cos(#{params[:gps_lat_drivers]} * Math.pi() / 180) * Math.cos(`gps_lat_user` * Math.pi() / 180) * Math.cos((#{params[:gps_long_drivers]} – `gps_long_user`) * Math.pi() / 180)) * 180 / Math.pi()) * 60 * 1.1515)and status=1").order("((Math.acos(Math.sin(#{params[:gps_lat_drivers]} * Math.pi() / 180) * Math.sin(`gps_lat_user` * Math.pi() / 180) + Math.cos(#{params[:gps_lat_drivers]} * Math.pi() / 180) * Math.cos(`gps_lat_user` * Math.pi() / 180) * Math.cos((#{params[:gps_long_drivers]} – `gps_long_user`) * Math.pi() / 180)) * 180 / Math.pi()) * 60 * 1.1515) ").limit(10).all

    #pi=Math::PI
    #a=Math. .sin(x)
    #result=Order.where("2*6371*asin(sqrt(pow(sin(lat1-lat2)*pi/180/2)")

    return render json: {text: "enjoy"}

  end
  def accept
    u=User.find(params[:driver_id])
    return render json: {errors: "Yu nat driver"} if !d=u.driver
    o=Order.find(params[:order_id])
    return render json: {error: "Orders busy"} if o && o.order_accept       # -check- -> #  else return render json: {text: "order tut"}
                                                                                      #o.driver=u.driver.order #
                                                                                      #d=u.driver
                                                                                      #o.driver=d.order
    o.driver_id=u.device_id
    o.gps_lat_drivers=params[:gps_lat_drivers]
    o.gps_long_drivers=params[:gps_long_drivers]
    o.order_accept=1
    o.save
    return render json: {message:"Your order"}
  end
  def cancel
    u=User.find(params[:driver_id])
    return render json: {errors: "Yu nat driver"} if !d=u.driver
    o=Order.find(params[:order_id])
    o.driver_id=0
    o.gps_lat_drivers=0
    o.gps_long_drivers=0
    o.order_accept=false
    o.save
    #u.points-=1
    #u.save
    return render json: {message: "Taken you order transferred to the free mode"}
  end
end


