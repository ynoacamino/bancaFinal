addEventListener("load", getCards);

function getCards() {
    fetch2([], [], "lista_tarjetas.pl", function (response) {
        const cards = response.getElementsByTagName("card");
        for (let i = 0; i < cards.length; i++) {
            let id = cards[i].getElementsByTagName("id")[0].childNodes[0].nodeValue;
            let card_number = cards[i].getElementsByTagName("card_number")[0].childNodes[0].nodeValue;
            let code = cards[i].getElementsByTagName("code")[0].childNodes[0].nodeValue;
            let expire_date = cards[i].getElementsByTagName("expire_date")[0].childNodes[0].nodeValue;
            let currency = cards[i].getElementsByTagName("currency")[0].childNodes[0].nodeValue;
            createCardElement([id, card_number, code, expire_date, currency]);
        }
    });
}

function createCardElement(values) {
    const movementElement = document.createElement("div");
    movementElement.classList.add("card");

    for (let i = 0; i < values.length; i++) {
        createCardSubElement(movementElement, values[i]);
    }

    document.getElementById("cards").appendChild(movementElement);
}

function createCardSubElement(parentElement, value) {
    const element = document.createElement("h4");
    element.style = "display: inline;"
    element.innerHTML = value + " ";
    parentElement.appendChild(element);
}