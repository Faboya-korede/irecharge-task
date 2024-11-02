import { user } from "./contant.mjs";

export const middleware = (req, res, next) => {

    const {
        body,
        params: {id},
    } =  req;

    const parsedId = parseInt(id);
    if (isNaN(parsedId)) return res.status(400).send({msg: "inavlid requet"})
    const finduser =  user.findIndex((user) => user.id === parsedId );
    if (finduser === -1) return res.sendStatus(404);
    req.finduser = finduser
    next();

}