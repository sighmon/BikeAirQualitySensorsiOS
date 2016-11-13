# Bike air quality sensors iOS

<img src="https://raw.githubusercontent.com/sighmon/BikeAirQualitySensorsiOS/master/iOS-screenshot.jpg" width="100%" />

This is a Bluetooth 4 (BLE) iOS app that receives air quality data from a corresponding [Arduino project](https://github.com/sighmon/bike_air_quality_sensors), adds a timestamp and GPS coordinates, and saves that data to a file/website.

## Air quality data

Air quality data is logged from these sensors on the Arduino project:

* MQ-7 Carbon Monoxide sensor
* GP2Y10 Dust Particle sensor
* DHT-22 Temperature/Humidity sensor

For more information see: [bike_air_quality_sensors](https://github.com/sighmon/bike_air_quality_sensors)

Then the iOS app adds:

* ISO 8601 formatted time, including the time zone.
* The position - latitude, longitude and accuracy.

## Bluetooth BLE hardware

I'm using the [RedBear BLE Nano](http://redbearlab.com/blenano/) for this project - the only limitation I've found so far is that it's a 3.3v board, and the rest of my project is 5v. Powering it via 5v is fine, but I need to step down the voltage on the serial line to the BLE Nano to avoid frying it.

## iOS demo project

This app is based on the [RedBear SimpleControls example project](https://github.com/RedBearLab/iOS/tree/master/Examples/SimpleControls_iOS).


### Where to buy the BLE Nano in Australia?

I have no affiliation with this company other than a great experience as a customer.

[BLE Nano from LittleBird Electronics](http://littlebirdelectronics.com.au/collections/redbearlabs/products/ble-nano-kit).
