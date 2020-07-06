This project was bootstrapped with [Create React App](https://github.com/facebook/create-react-app).

## Available Scripts

In the project directory, you can run:

### `npm start`

Runs the app in the development mode.<br />
Open [http://localhost:3000](http://localhost:3000) to view it in the browser.

The page will reload if you make edits.<br />
You will also see any lint errors in the console.

### `npm test`

Launches the test runner in the interactive watch mode.<br />
See the section about [running tests](https://facebook.github.io/create-react-app/docs/running-tests) for more information.

### `npm run build`

Builds the app for production to the `build` folder.<br />
It correctly bundles React in production mode and optimizes the build for the best performance.

The build is minified and the filenames include the hashes.<br />
Your app is ready to be deployed!

See the section about [deployment](https://facebook.github.io/create-react-app/docs/deployment) for more information.

### `npm run eject`

**Note: this is a one-way operation. Once you `eject`, you can’t go back!**

If you aren’t satisfied with the build tool and configuration choices, you can `eject` at any time. This command will remove the single build dependency from your project.

Instead, it will copy all the configuration files and the transitive dependencies (webpack, Babel, ESLint, etc) right into your project so you have full control over them. All of the commands except `eject` will still work, but they will point to the copied scripts so you can tweak them. At this point you’re on your own.

You don’t have to ever use `eject`. The curated feature set is suitable for small and middle deployments, and you shouldn’t feel obligated to use this feature. However we understand that this tool wouldn’t be useful if you couldn’t customize it when you are ready for it.

## Learn More

You can learn more in the [Create React App documentation](https://facebook.github.io/create-react-app/docs/getting-started).

To learn React, check out the [React documentation](https://reactjs.org/).

### Code Splitting

This section has moved here: https://facebook.github.io/create-react-app/docs/code-splitting

### Analyzing the Bundle Size

This section has moved here: https://facebook.github.io/create-react-app/docs/analyzing-the-bundle-size

### Making a Progressive Web App

This section has moved here: https://facebook.github.io/create-react-app/docs/making-a-progressive-web-app

### Advanced Configuration

This section has moved here: https://facebook.github.io/create-react-app/docs/advanced-configuration

### Deployment

This section has moved here: https://facebook.github.io/create-react-app/docs/deployment

### `npm run build` fails to minify

This section has moved here: https://facebook.github.io/create-react-app/docs/troubleshooting#npm-run-build-fails-to-minify

# Config.js
  Please create S3 Bucket, Cognito User Pool & ognito Test User using below mentioned links.

  * Create an S3 Bucket - https://serverless-stack.com/chapters/create-an-s3-bucket-for-file-uploads.html
  * Manually Create a Cognito User Pool - https://serverless-stack.com/chapters/create-a-cognito-user-pool.html
  * Manually Create a Cognito Test User - https://serverless-stack.com/chapters/create-a-cognito-test-user.html

	```
	export default {
      s3: {
        REGION: "YOUR_S3_UPLOADS_BUCKET_REGION",
        BUCKET: "YOUR_S3_UPLOADS_BUCKET_NAME"
      },
      apiGateway: {
        REGION: "YOUR_API_GATEWAY_REGION",
        URL: "YOUR_API_GATEWAY_URL"
      },
      cognito: {
        REGION: "YOUR_COGNITO_REGION",
        USER_POOL_ID: "YOUR_COGNITO_USER_POOL_ID",
        APP_CLIENT_ID: "YOUR_COGNITO_APP_CLIENT_ID",
        IDENTITY_POOL_ID: "YOUR_IDENTITY_POOL_ID"
      }
    };

	```
    Here you need to replace the following:
    1. `YOUR_S3_UPLOADS_BUCKET_NAME` and `YOUR_S3_UPLOADS_BUCKET_REGION` with the your S3 Bucket name and region from the 
       [Create an S3 bucket for file uploads](https://serverless-stack.com/chapters/create-an-s3-bucket-for-file-uploads.html) chapter. 
       In our case it is `notes-app-uploads` and `us-east-2`.

    2. `YOUR_API_GATEWAY_URL` and `YOUR_API_GATEWAY_REGION` with the ones from the [Deploy the APIs](https://serverless-stack.com/chapters/deploy-the-apis.html) chapter. In our case the 
       URL is https://ly55wbovq4.execute-api.us-east-2.amazonaws.com/prod and the region is `us-east-2`.

    3. `YOUR_COGNITO_USER_POOL_ID`, `YOUR_COGNITO_APP_CLIENT_ID`, and `YOUR_COGNITO_REGION` with the Cognito Pool Id, App Client id, 
       and region from the [Create a Cognito user pool](https://serverless-stack.com/chapters/create-a-cognito-user-pool.html) chapter.

    4. `YOUR_IDENTITY_POOL_ID` with your Identity pool ID from the [Create a Cognito identity pool](https://serverless-stack.com/chapters/create-a-cognito-identity-pool.html) chapter.

# References

* Terraform - AWS_Cognito_user_pools - https://www.terraform.io/docs/providers/aws/d/cognito_user_pools.html
* Terraform - AWS_cognito_user_pool_client - https://www.terraform.io/docs/providers/aws/r/cognito_user_pool_client.html
* Terraform - AWS_s3_bucket - https://www.terraform.io/docs/providers/aws/d/s3_bucket.html

