<!-- Go to https://github.com/Thangiee/MARS-deployment to view this README rendered as a web page (easier to read). --> 

# MARS-deployment

Instructions to deploy the Mavericks Assistants Reporting System (MARS).


## 1. Setting up Amazon EC2

If you have your own server ready, you can skip to the next part.

Log into the [AWS Console](https://aws.amazon.com/console/), navigate to the EC2 section and go the **Instances**:

Press the Launch Instance button. You should be presented with Quick Start wizard:

Choose to launch an Amazon Linux AMI instance, and press the Select button.

Select a suitable instance type. **t2.micro** instance type is the lowest tier that MARS can be successfully deployed 
to. If MARS user base grows, you will likely need to upgrade to a higher tier.

Select the **Configure Security Group** tab at the top. Click the Add Rules button and open ports like the following:

Click on Review and Launch button once you are done.

At this point you should be prompted to either select an existing key pair or create a new one (or even not having one 
which is not recommended).
 
The key file allows you to securely SSH into your instance.You have to download the private key file (*.pem file) before
you can continue. Store it in a secure and accessible location. You will not be able to download the file again after 
it's created. Once downloaded (in the form of a .pem file), you will need to make sure it is not publicly viewable by
executing the following at the command line:
```
$ chmod 400 $key-pair-name.pem
```

Once you are back to the Instances page, select your newly created instance and note the **Public IP**. 

Now right click on your instance and select connect. This will show you how to **SSH** to into your instance.

## 2. Configure MARS to run on your server
On your computer, open the file `docker-compose.yml` with your favorite text editor. 

Now you will need to configure a few variables for MARS to run correctly:

#### `MARS_PLAY_SECRET`
For security purpose, you need to change the value of this variable to something random and unique.
One way to do this is to visit http://randomkeygen.com/ and copy the **504-bit WPA Key** and replace 
the `changeme` value with the key.

Example:

#### `MARS_PUBLIC_ADDR`
Use your instance public IP address noted earlier or a domain name if available.

#### `MARS_EMAIL_ADDR`
The email address this system will use to email notifications and time sheets.

#### `MARS_EMAIL_HOST`
The host that will send the email.
Beware of Gmail 24-hours sending limit (https://support.google.com/a/answer/166852?hl=en).
For large user base, consider using Amazon SES or something similar instead.
Note that you can use a gmail accout with Amazon SES.

google ex: MARS_EMAIL_HOST=smtp.gmail.com

Amazon SES ex: MARS_EMAIL_HOST=email-smtp.us-west-2.amazonaws.com

#### `MARS_EMAIL_SMTP_USER`
If using google as host, this field will be the same as the `MARS_EMAIL_ADDR` field above.

For amazon SES, see http://docs.aws.amazon.com/ses/latest/DeveloperGuide/smtp-credentials.html.

#### `MARS_EMAIL_SMTP_PASSWORD`
If using google as host, this is the password of the email addr.

For amazon SES, see http://docs.aws.amazon.com/ses/latest/DeveloperGuide/smtp-credentials.html.

#### `MARS_FACEPP_KEY` and `MARS_FACEPP_SECRET`
MARS uses face++ apis to do facial recognition (http://www.faceplusplus.com/api-overview/).
This requires signing up and getting an api key and secret.
50,000 api calls per month. More details at http://www.faceplusplus.com/apilimit

#### `POSTGRES_PASSWORD` and `MARS_DB_PASSWORD`



#### Other configurations
See https://github.com/Thangiee/MARS-back-end/blob/master/src/main/resources/application.conf for details of other variables.


## 3. Starting up MARS

## 4. 
