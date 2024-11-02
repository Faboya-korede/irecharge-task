# Use a specific base image with Node.js 21
FROM node:21-alpine 

# Set the working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy the entire current directory into the container
COPY . .

# Expose port 8000
EXPOSE 3000

# Specify the command to run your application
CMD ["npm", "run", "start:dev"]