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

function createStatusElements(errors) {
    for (let i = 0; i < errors.length; i++) {
        let element = errors[i].getElementsByTagName("element")[0].firstChild.nodeValue;
        let message = errors[i].getElementsByTagName("message")[0].firstChild.nodeValue;
        let statusElement = document.getElementById("status_" + element);
        if (statusElement) {
            statusElement.remove();
        }
        createElement(element, message);
    }
}

function createElement(element, message) {
    const statusElement = document.createElement("h3");
    const placeElement = document.getElementById(element);

    if (message != "Correcto") {
        placeElement.classList.add("error");
        statusElement.classList.add("error");
    } else {
        placeElement.classList.remove("error");
    }

    statusElement.id = "status_" + element;
    statusElement.innerHTML = message;
    document.getElementById("content").insertBefore(statusElement, placeElement);
}