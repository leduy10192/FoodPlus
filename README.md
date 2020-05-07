# FoodPlus

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)
2. [Demo](#Demo)

## Overview
### Description
This app helps restaurant sell excess food at discounted price and helps consumers find food sources. This provides a way to reduce food waste and food insecurity.

### App Evaluation
- **Category:** Commercial App
- **Mobile:** This app will be developed for mobile platforms but can also have an web-app version with the same functionality.
- **Story:** Food sellers post items. Food consumers search and place order.
- **Market:** Any individual that have access to mobile apps but primarily focus on people facing food insercurity.
- **Habit:** This app can be very used very often at the end of every day but depending on food availability as well.
- **Scope:** Food consumers depend on the location of food providers. This app can add location tracker and traveling time estimating feature.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Food provider
   - [x] New users can register
   - [x] User logs into app
   - [x] Users can view their information
   - [x] User can view current item list
   - [x] User can add a new item to the item list
   - [ ] User can edit their info and items in the list
* Food consumer
   - [x] User logs into app
   - [x] User can view current dishes
   - [x] User can search for food based on name and location
   - [x] User can add a dish to cart
   - [x] User can place order
   
**Optional Nice-to-have Stories**

* Location tracker

### 2. Screen Archetypes

* Food provider
   * Login
   * Register
   * Home Screen
   * Add Item Screen
* Food consumer
   * Login
   * Register
   * Home Screen
   * Cart Screen
   * Add Payment Screen
   * Confirmation Screen

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home Screen
* Add Item Screen
* Cart Screen

**Flow Navigation** (Screen to Screen)

* Login -> Home Screen
* Home Screen -> Add Item Screen
* Home Screen -> Cart Screen

## Wireframes

<img src="https://user-images.githubusercontent.com/47465901/79528144-1224d780-801e-11ea-8c56-222d84db0fa8.png" width=850>

### [BONUS] Digital Wireframes & Mockups

<h4>Seller Screen </h4>
<p float="left">
<img src="https://user-images.githubusercontent.com/47465901/79529454-8e6cea00-8021-11ea-862b-00bc0adec5a3.png" width = 200 hspace = 20>
<img src="https://user-images.githubusercontent.com/47465901/79529513-b52b2080-8021-11ea-865a-7be58bdfe19f.png" width = 200>
</p>
<h4>Buyer Screen </h4>
<p float="left">
<img src="https://user-images.githubusercontent.com/47465901/79529750-54e8ae80-8022-11ea-851b-389f74c6cd00.png" width = 200 hspace = 20>
<img src="https://user-images.githubusercontent.com/47465901/79530036-16072880-8023-11ea-803e-47d5c8cb6030.png" width = 200>
</p>

### [BONUS] Interactive Prototype

<img src="http://g.recordit.co/d88T9J4vJ0.gif" width=250>

## Schema
### Model
<img src="https://user-images.githubusercontent.com/47465901/80168059-ced6e580-8596-11ea-9f7a-c7a7b6c90563.png" width = 500>

### Networking
* Authentication with Firestore
* Fetch restaurant order
* Add new order collection
* Update restaurant order
* Fetch/Delete member cart items
* Fetch/Add member order items
* Update order status

<img src = "https://user-images.githubusercontent.com/47465901/80168641-3b061900-8598-11ea-99c2-d78669c488cc.png" width = 700>

## Demo
### [Video Demo](https://www.youtube.com/watch?v=SSrVYSqR3QE)
[![](https://img.youtube.com/vi/SSrVYSqR3QE/0.jpg)](https://www.youtube.com/watch?v=SSrVYSqR3QE)

### Restaurant Gifs
<p float="left">
<img src = "http://g.recordit.co/KxrQjfFv3p.gif" width = 200 >
<img src = "http://g.recordit.co/EJTytGCpCY.gif" width = 200 hspace = 120>
<img src = "http://g.recordit.co/zDrqovgRrH.gif" width = 200 >
</p>

### Member Gifs
<p float="left">
<img src = "http://g.recordit.co/c41XgyGvkO.gif" width = 200 >
<img src = "http://g.recordit.co/PF8ajngEiS.gif" width = 200 hspace = 120>
</p>

## License

    Copyright [2020] [Duy Le]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
