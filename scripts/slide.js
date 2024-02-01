let selectedIdx = 1;
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
    selectedIdx = Math.max(1, Math.min(selectedIdx - 1, cards.length));
    document.getElementById(selectedIdx).checked = true;
  });

  next.addEventListener("click", () => {
    slide.scrollLeft += 400;
    selectedIdx = Math.max(1, Math.min(selectedIdx + 1, cards.length));
    document.getElementById(selectedIdx).checked = true;
  });

  /*contentCards.addEventListener("click", () => {
    setTimeout(() => {
      updateSelectedCard();
    }, 300);
  });*/
}

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

