addEventListener("load", getStatus);

function getStatus() {
    const xhttp = new XMLHttpRequest();

    xhttp.onreadystatechange = function () {
        if (xhttp.readyState == 4 && xhttp.status == 200) {
            const response = xhttp.responseXML;
            const balance = response.getElementsByTagName("balance")[0].childNodes[0].nodeValue;
            createBalanceElement(balance);

            const movements = response.getElementsByTagName("movement");
            for (let i = movements.length - 1; i >= 0; i--) {
                let amount = movements[i].getElementsByTagName("amount")[0].childNodes[0].nodeValue;
                let type = movements[i].getElementsByTagName("type")[0].childNodes[0].nodeValue;
                let date = movements[i].getElementsByTagName("date")[0].childNodes[0].nodeValue;
                createMovementElement(amount, type, date);
            }
        }
    };

    xhttp.open("POST", "./cgi-bin/estado.pl", true);
    xhttp.send();
}

function createBalanceElement(balance) {
    const balanceElement = document.createElement("h4");
    balanceElement.innerHTML = balance;
    document.getElementById("balance").appendChild(balanceElement);
}

function createMovementElement(amount, type, date) {
    const movementElement = document.createElement("div");
    movementElement.classList.add("movement");

    const amountElement = document.createElement("h5");
    const typeElement = document.createElement("h5");
    const dateElement = document.createElement("h5");
    amountElement.innerHTML = amount;
    typeElement.innerHTML = type;
    dateElement.innerHTML = date;

    movementElement.appendChild(amountElement);
    movementElement.appendChild(typeElement);
    movementElement.appendChild(dateElement);

    document.getElementById("movements").appendChild(movementElement);
}