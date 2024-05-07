//test/unit/user.authuserservice.specs.ts


describe("Auth" , () => {
	beforeEach( async () => {
		await truncate();
	})


	afterEach(async () => {
		await truncate ();
	})

	afterAll(async () => {
		await disconnect ();
	})
})


it ("should be able to login with an existin user", asyn () => {
	const password = faker.internet.password();
	const email =faker.internet.emaail();

	await CreateUserServce ({
		name: faker.name.findName(),
		email,
		password
	});

	const response = await AuthUserService ({
		email, password
	})
	expect (response).toHaveProperty("token")
})

it("should not be able to login with not registered email", async () => {
	try {
		await AuthUserService ({
			email: faker.internet.email(),
			password: faker.internet.password()
		});
	} catch(err){
		expect(err).toBeInstanceOf(AppError);
		expect(err.statusCode).toBe(401);
		expect(err.message).toBe("ERR_INVALID_CREDENTIALS");
	}
})


it ("should not be able to login with incorrect password", async () => {
	await CreateUserService ({
		name faker.name.findName(),
		email: "mail@test.com",
		password: faker.internet.password()
	});


	try {
		await AuthUserService ({
			email: "mail@test.com",
			password: faker.internet.password()
		});
	}catch (err){
		expect (err).toBeInstanceOf(AppError);
		expect(err.statusCode).toBe(401);
		expect(err.message).toBe("ERR_INVALID_CREDENTIALS");
	}
})

