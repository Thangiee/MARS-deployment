<!-- Go to https://github.com/Thangiee/MARS-deployment to view this README rendered as a web page (easier to read). --> 

# MARS-deployment

MARS(Mavericks Assistants Reporting System) compose of these components:
* [MARS-back-end](https://github.com/Thangiee/MARS-back-end)
* [MARS-admin-website](https://github.com/Thangiee/MARS-admin-website)
* [MARS-android-app](https://github.com/Thangiee/MARS-android-app)
* [MARS-iOS-app](https://github.com/bernaedeeann/MARS-iOS)
* [MARS-QR-gen](https://github.com/Thangiee/MARS-QR-gen)

Below are instructions to deploy the database, the back-end server, and the admins' website.

## 1. Setting up Amazon EC2

If you have your own server ready, you can skip to the [next part](#2-configure-mars-to-run-on-your-server).

Log into the [AWS Console](https://aws.amazon.com/console/), navigate to the EC2 section and go the **Instances**:
Press the Launch Instance button. You should be presented with Quick Start wizard:

![img1](https://github.com/snowplow/snowplow/wiki/setup-guide/images/postgresql/aws-ec2-console.jpg)

Choose to launch an Amazon Linux AMI instance, and press the Select button.

![img2](https://github.com/snowplow/snowplow/wiki/setup-guide/images/postgresql/ec2-quick-launch-wizard.jpg)

Select a suitable instance type. **t2.micro** instance type is the lowest tier that MARS can be successfully deployed 
to. If MARS user base grows, you will likely need to upgrade to a higher tier.

![img3](https://github.com/snowplow/snowplow/wiki/setup-guide/images/postgresql/choose-instance-type.jpg)

Select the **Configure Security Group** tab at the top. Click the Add Rules button and open ports like the following:

![img4](https://cloud.githubusercontent.com/assets/4734933/15060961/75f80da8-12f5-11e6-9bc5-17f53ab93118.png)

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

![img5](https://cloud.githubusercontent.com/assets/4734933/15061152/83da6c70-12f7-11e6-91b1-6b96618c4375.png)

Now right click on your instance and select connect. This will show you how to **SSH** to into your instance.

## 2. Configure MARS to run on your server
On your computer, open the file `docker-compose.yml` with your favorite text editor. 

Now you will need to configure a few variables for MARS to run correctly:

#### `MARS_PLAY_SECRET`
For security purpose, you need to change the value of this variable to something random and unique.
One way to do this is to visit http://randomkeygen.com/ and copy the **504-bit WPA Key** and replace 
the `changeme` value with the key.

Example:
![img6](https://cloud.githubusercontent.com/assets/4734933/15090279/b9a7d774-13e8-11e6-9f28-75de4634595d.png)

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

* Api key under developer status can NOT register more than 100 assistants to Face++ system. 
  You may need to apply for deployment status to remove the limit. 
* 50,000 api calls per month. More details at http://www.faceplusplus.com/apilimit

#### `POSTGRES_PASSWORD` and `MARS_DB_PASSWORD`
It is suggested that you change the default database password something stronger. 
**These two variable must have the same password value!**

#### Other configurations
See https://github.com/Thangiee/MARS-back-end/blob/master/src/main/resources/application.conf for details of other variables.

## 3. Launching MARS

With the configurations set up, we are ready to start up MARS.

1. Move the MARS-deployment directory/fold to your server using but not limiting to `FTP/SFTP` 
   and `scp` ([Example](#http://www.hypexr.org/linux_scp_help.php), [Bottom section](#http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html)).
2. SSH into your server if you have not done so. 

3. On your server, `cd` into the MARS-deployment directory.

4. Once you changed to said directory, run: 
   ```
   $ chmod a+x ./*.sh
   ```
   
5. Execute the setup script:
   ```
   $ ./amazon-linux-setup.sh
   ```
   
   This will install docker and docker-compose for you. 
   
   If you are not using amazon-linux, see instructions below to install docker and docker-compose for your respective systems.
   * https://docs.docker.com/engine/installation/
   * https://docs.docker.com/compose/install/
   
6. Once you changed to said directory, run:
   ```
   $ sudo docker-compose build
   ```
   
   Wait for it to finish downloading then run:
   ```
   $ sudo docker-compose up -d
   ```
   
   Once that finish, the database, the back-end server, and the admins' website should be up and running.

Useful commands (also needs to be inside the MARS-deployment directory):
  * `$ docker-compose down` to stop the MARS.
  * `$ docker-compose logs` to view logs.
  * `$ docker-compose ps` to view information of up and running MARS components.
  * Details of other commands for [docker-compose](#https://docs.docker.com/compose/reference/) and [docker](#https://docs.docker.com/engine/reference/commandline/cli/)
  
## 4. Setting up admin account

If everything is set up correctly, you should be able to visit the admin web site by entering your server public IP
address or domain name into your web browser. 
                            
Once on the website, follow these steps to set up your admin account:

1. Click the **Sign up** button and sign up an account.

2. Back at the login page, login using the default admin account with username `admin` and password is `password`.

3. Go to the **Approval** in the menu on the left.

4. Switch to the **Instructors** tab and approve the account you just sign up for.

5. Next, go to **Account Mngt.** in the menu.

6. Again, switch to the instructors tab.

7. Click on your account and toggle the account's role from instructor to admin.

8. Log out and log back in using the account you created.

9. Go back to the **Account Mngt.** page and switch to the admins tab.

10. Delete the default admin account by typing in net ID `abc123` to confirm deletion.

## Backing up data

While MARS is up and running, you can make a backup at any time by running the backup script located 
in the MARS-deployment directory.
 ```
 $ ./make-backup.sh
 ```

This script will generate (inside MARS-deployment directory):
* `./backup/{date and time of backup}/db.sql` - File containing all the data in the database.
* `./backup/{date and time of backup}/faces` - Directory containing all assistants' face images used for facial recognition.

Example:
* `./backup/2016-05-06_07:46/db.sql`
* `./backup/2016-05-06_07:46/faces`

## Restoring data

To restore a previous backup, replace `./database/db.sql` and `./backend/faces` with their respective backup file.

Next, stop MARS with:
```
$ docker-compose down -v
```

then:
```
$ docker-compose build
```

finally:
```
$ docker-compose up -d
```