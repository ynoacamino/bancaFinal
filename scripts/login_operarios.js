function login() {
    fetch2(["user", "password"], ["type=operario"], "login.pl", function(response) {
        const errors = response.getElementsByTagName("error");
        if (errors.length != 0) {
            createStatusElements(errors);
        } else {
            window.location = "./index_operarios.html";    
        }
    })
}