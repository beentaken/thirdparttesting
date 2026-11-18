db = db.getSiblingDB("mongodb_test");

db.createCollection("employees");

db.employees.insertMany([
    {
        id: 1,
        name: "John",
        department: "IT"
    },
    {
        id: 2,
        name: "Mary",
        department: "HR"
    }
]);

print("MongoDB initialization completed");