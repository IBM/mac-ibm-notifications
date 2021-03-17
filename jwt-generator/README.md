Generates signed JWT with specific claims for Mac@IBM Notifications Deep Link engine and optional custom validity

**Usage**  
This project uses Python 3 and Pipenv for dependency management.  
Before running the script please install all required dependencies by running  
`pip3 install -r requirements.txt` 

Then run  and follow instructions  
`./jwtgenerator.py -h`

To quickly generate json web token run  
`./jwtgenerator.py resources/certificates/private.key`

By default the token expiration is set to 600 seconds

To change token expiration run  
`./jwtgenerator.py resources/certificates/private.key -e SECONDS`

 To generate new production ready public/private key pair with strong encryption run   
 `./keygen.sh`
 
 It will generate and also print out both private  and public key.  
