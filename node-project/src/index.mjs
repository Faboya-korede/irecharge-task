import express from 'express';
import { middleware } from '../utils/mildewares.mjs';
import { user } from '../utils/contant.mjs'
import { body, query, validationResult } from "express-validator";

const app = express ();

const logging = (req, res, next) => {
    res.on('finish', () =>{

    console.log (`${req.method} - ${req.url} - ${res.statusCode}`)
})
next()
};

app.use(express.json());

app.use(logging);


app.get('/', (req, res) => {
    const currentTime = new Date().toISOString(); // UTC format
    res.status(200).send({ msg: `timestamp: ${currentTime}`});
});

app.get('/api/user', query("filter").isString().notEmpty(), (req, res) =>{
    //console.log(req.query);
    const result = validationResult(req);
    console.log(result)
    const {
        query: {filter, value},
    } = req;

    if (!filter && !value) return res.send(user)
    if (filter && value) return res.send(user.filter((user) => user[filter].includes(value)));  
});


app.post('/api/users', (req, res) => {
 console.log(req.body);
 const newUser = req.body;
 
 if (!newUser.name || !newUser.age) return res.status(400).send({ msg: "Name and age are required" });

  return res.status(201).send(newUser);
});

// PUT request handler to update a user by ID
app.put('/api/user/:id', middleware, (req, res) => {
    const {body, finduser} = req ;
    user[finduser] = {id: user[finduser].id, ...body}
    return res.sendStatus(200);

})

app.patch('/api/user/:id', middleware,  (req, res) => {
    const { body, finduser } = req ;
    user[finduser] = { ...user[finduser], ...body };
    return res.status(200).send({ msg: "User updated successfully" });
});

app.delete('/api/user/:id', middleware,  (req, res) => {
    const {body, finduser} = req; 
    user.splice(finduser, 1)
    return res.status(200).send({msg: "Account deleted succesfully"})
})


app.get('/api/user/:id', middleware, (req, res) =>{
    const { finduser} = req;
    const findUser = user[finduser];
if (!findUser) return res.sendStatus(404);
return res.send(findUser)
});

const PORT = process.env.PORT || 3000 ;
app.listen(PORT, () =>{
console.log(`Server is listening on ${PORT}`)
});

////