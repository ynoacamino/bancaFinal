let prev;
let next;
let slide;
let cards;
let contentCards;

function initCardSlide() {
  prev = document.querySelector(".prev");
  next = document.querySelector(".next");
  slide = document.querySelector(".slide");
  cards = document.querySelectorAll(".card");
  contentCards = document.querySelector(".cards");

  prev.addEventListener("click", () => {
    slide.scrollLeft -= 400;
    setTimeout(() => {
      updateSelectedCard();
    }, 300);
  });

  next.addEventListener("click", () => {
    slide.scrollLeft += 400;
    setTimeout(() => {
      updateSelectedCard();
    }, 300);
  });

  contentCards.addEventListener("click", () => {
    setTimeout(() => {
      updateSelectedCard();
    }, 300);
  });
}

function updateSelectedCard() {
  var containerCenter = slide.scrollLeft + slide.offsetWidth / 2;

  var closestCard;
  var minDistance = Infinity;

  // TODO: especificamente esta parte no funciona
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

