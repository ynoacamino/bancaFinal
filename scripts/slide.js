let prev = document.querySelector(".prev");
let next = document.querySelector(".next");
let slide = document.querySelector(".slide");
let cards = document.querySelectorAll(".card");
let contentCards = document.querySelector(".cards");

updateSelectedCard();

prev.addEventListener("click", function () {
  slide.scrollLeft -= 400;
  updateSelectedCard();
});

next.addEventListener("click", function () {
  slide.scrollLeft += 400;
  updateSelectedCard();
});

contentCards.addEventListener("click", () => {
  setTimeout(() => {
    updateSelectedCard();
  }, 300);
});

function updateSelectedCard() {
  var containerCenter = slide.scrollLeft + slide.offsetWidth / 2;

  var closestCard;
  var minDistance = Infinity;

  cards.forEach(function (card) {
    var cardCenter = card.offsetLeft + card.offsetWidth / 2;
    var distance = Math.abs(containerCenter - cardCenter);

    if (distance < minDistance) {
      minDistance = distance;
      closestCard = card;
    }
  });

  var inputRadio = closestCard.querySelector("input");
  inputRadio.checked = true;
}

