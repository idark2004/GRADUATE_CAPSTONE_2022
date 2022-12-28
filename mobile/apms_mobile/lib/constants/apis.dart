import 'dart:io';

const baseUrl = "http://18.136.151.97:6001/api";

Map<String, String> headers = {
  HttpHeaders.contentTypeHeader: 'application/json',
};

const carPark = "$baseUrl/carparks";
const login = "$baseUrl/Authentication/customer";
const signup = "$baseUrl/Customers";
const history = "$baseUrl/Tickets";
const tickets = "$baseUrl/tickets";
const checkIn = "$baseUrl/check-in/create-ticket";
const checkOut = "$baseUrl/check-out";
const changePassword = "$baseUrl/Accounts/update-password";
const feedback = "$baseUrl/Feedbacks";
const forgotPassword = "$baseUrl/Accounts/forgot-password";
const createNewPassword = "$baseUrl/Accounts/forgot-password/update-password";
const transactionHistory = "$baseUrl/Transactions";
