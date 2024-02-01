function getStatus() {
    fetch2([generateCardsQuery()], [], "estado_tarjeta.pl", function (response) {
        removeExistingElements();

        const balance = response.getElementsByTagName("balance")[0].childNodes[0].nodeValue;
        createBalanceElement(balance);

        const movements = response.getElementsByTagName("movement");
        for (let i = movements.length - 1; i >= 0; i--) {
            let amount = movements[i].getElementsByTagName("amount")[0].childNodes[0].nodeValue;
            let type = movements[i].getElementsByTagName("type")[0].childNodes[0].nodeValue;
            let date = movements[i].getElementsByTagName("date")[0].childNodes[0].nodeValue;
            createMovementElement([amount, type, date]);
        }
    });
}

function removeExistingElements() {
    let balanceElement = document.getElementById("balance_elem");
    let movementsElements = document.getElementsByName("movements_elem");
    if (balanceElement) {
        balanceElement.remove();
    }
    // Recuerdos de 'concurrent modification exception'
    const leng = movementsElements.length;
    for (let i = 0; i < leng; i++) {
        movementsElements[0].remove();
    }
}

function createBalanceElement(balance) {
    const balanceElement = document.createElement("h5");
    balanceElement.style = "font-size: 20px;"
    balanceElement.innerHTML = balance;
    balanceElement.id = "balance_elem";
    document.getElementById("balance").appendChild(balanceElement);
}

function createMovementElement(values) {
    const movementElement = document.createElement("div");
    movementElement.setAttribute("name", "movements_elem");
    movementElement.classList.add("movement");

    for (let i = 0; i < values.length; i++) {
        createMovementSubElement(movementElement, values[i]);
    }

    document.getElementById("movements").appendChild(movementElement);
}

function createMovementSubElement(parentElement, value) {
    const element = document.createElement("h5");
    element.innerHTML = value;
    parentElement.appendChild(element);
}