#Striptease - a simple webcomics management script
 2013 Mathilda Hartnell

This is a simple Sinatra script that allows you to host and manage a webcomic.

This project is still very early in development, but it's usable enough for now. Further development is to be expected.

##Installation

1. Clone this github repo into a directory of your choice on your server.
2. Install the gems `sinatra`, `datamapper`, `dm-sqlite-adapter`
3. Edit the `striptease.rb` file. Change the following lines to a secure username and password:
    set :username, "admin"
    set :password, "default"
4. Right under that, there's a line `set :port, 80`. Ask your administrator whether or not this port is free on your server (or which one you can use). Be sure to bind your domain names and whatnot to the correct port.
5. Run the script: `ruby striptease.rb`
6. The admin panel is located under `http://your_server/admin`

##Customization

The .html template files are in the `/views` directory as .erb files - basically regular HTML with bits of ruby in the <% %> tags, the stylesheet is in `/public`. I'm working on editing these from the admin panel.

##Word of warning

This is a horribly early alpha. Pretty much the only thing you can do with this now is adding and removing strips. I'm working on this in my spare time, but if you want to help me with development, feel free to send me an e-mail (nekkoru@gmail.com).