**Local set up guide -**

If you want to run it on local follow the steps below
- take clone from github
- Install rails 6
- Install ruby 2.7.2
- Do bundle install inside the folder
- Change database credentials in database.yml accordingly
- Run rake db:create
- Run rake db:migrate
- Run rake db:seed (to create required data of users, books, magazines, subscriptions plans etc)

Now you are ready to run the apis!

You can run the test cases with rspec command.
<br>
<br>

**API Documentation -** 

1. **List books and magazines** - GET localhost:3000/api/v1/items <br>
Params - email:rupesh@gmail.com, page:1

2. **Place order form books and magazines** - POST localhost:3000/api/v1/transactions/place_order <br>
Params - email:rupesh@gmail.com, item_id:5, item_type:book

3. **List borrowed books and magazines by the user** - GET localhost:3000/api/v1/users/transactions <br>
Params - email:rupesh@gmail.com, page:1

4. **Return books and items** - PATCH localhost:3000/api/v1/transactions/return_items <br>
Params - email:rupesh@gmail.com, transaction_ids:[15, 16]
<br>
<br>

**The basic api flow is -** 

List Books and Magazines API <br>
  ↓<br>
User views list of available books and magazines<br>
  ↓<br>
Place Order for Book or Magazine API<br>
  ↓<br>
User selects book or magazine using ID from list API<br>
  ↓<br>
Check Currently Borrowed Books or Magazines API<br>
  ↓<br>
User checks currently borrowed books and magazines<br>
  ↓<br>
Return Items API<br>
  ↓<br>
User selects items to return and obtains Transaction IDs from currently borrowed items<br>
  ↓<br>
User provides Transaction IDs to return the items<br>
<br>
As per the instruction I have not implemented the authentication. User will have to verify his email before every api call because of the absence of the authentication.
<br>
<br>


**Design -**

You have the following models here.

**User:**
- Each user can have multiple transactions and subscriptions.
- It belongs to a current subscription, which is an instance of the Subscription model. This association is named current_subscription.
- The current_subscription association is optional, meaning a user may not have a current subscription.

**SubscriptionPlan:**
- Describes the available subscription plans. (Silver, gold, platinum)
- Each plan can have multiple subscriptions.

**Subscription:**
- Represents a subscription purchased by a user.
- Belongs to a user and a subscription plan  with start and end date

**Book and Magazine:**
- Both models represent items available for transactions with details like title, genre, quantity
- Each item can have multiple transactions associated with it.

**Transaction:**
- Represents a transaction made by a user.
- Belongs to a user and can optionally belong to either a book or a magazine.

This design allows users to have subscriptions and perform transactions for borrowing books and magazines. Each subscription is associated with a subscription plan, and each transaction records the user's borrowing and returning activity. Let me know if you need further clarification!
<br>
<br>

**Topics Covered -**
- List books and magazines.
- Place order enforcing borrowing limits and constraints.
- List borrowed books and magazines by the user ordered by ordered date in descending order.
- Return borrowed books and magazines.
- All the api responses are designed in the way that they can be used for both mobile and web applications.

