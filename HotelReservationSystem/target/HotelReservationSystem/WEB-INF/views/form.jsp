<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${mode == 'edit' ? 'Edit' : 'New'} Reservation - Hotel Reservation System</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
  <c:set var="currentPage" value="${mode == 'edit' ? 'list' : 'add'}"/>
  <%@ include file="nav.jsp" %>

  <main class="main-content">
    <section class="hero-panel compact-hero">
      <div>
        <p class="hero-kicker">${mode == 'edit' ? 'Update stay' : 'Book a stay'}</p>
        <h1>${mode == 'edit' ? 'Edit reservation' : 'New reservation'}</h1>
        <p>Select the room and dates to calculate the total payment automatically.</p>
      </div>
      <a href="${pageContext.request.contextPath}/reservations?action=list"
         class="btn btn-outline btn-sm">&larr; Back to List</a>
    </section>

    <div class="page reservation-page fade-in">
      <div class="card reservation-card">
        <div class="card-header reservation-header">
          <div>
            <div class="form-eyebrow">${mode == 'edit' ? 'Update booking' : 'Guest booking'}</div>
            <div class="card-title">${mode == 'edit' ? 'Edit Guest Details' : 'Add New Reservation'}</div>
            <div class="card-subtitle">Choose the room and stay dates to calculate the payment.</div>
          </div>
        </div>

        <form action="${pageContext.request.contextPath}/reservations?action=save"
              method="post" id="reservationForm">
          <input type="hidden" name="action" value="save">
          <input type="hidden" id="price" name="price" value="${form.price}">
          <c:if test="${not empty form.id}">
            <input type="hidden" name="id" value="${form.id}">
          </c:if>

          <div class="form-grid reservation-form-grid">

            <div class="form-group">
              <label for="guestName">Guest Name *</label>
              <input type="text" id="guestName" name="guestName"
                     value="${form.guestName}" placeholder="e.g. Arun Kumar" required>
              <c:if test="${not empty form.errors['guestName']}">
                <span class="field-error">${form.errors['guestName']}</span>
              </c:if>
            </div>

            <div class="form-group">
              <label for="phone">Phone Number *</label>
              <input type="tel" id="phone" name="phone"
                     value="${form.phone}" placeholder="e.g. 0719883692" required>
              <c:if test="${not empty form.errors['phone']}">
                <span class="field-error">${form.errors['phone']}</span>
              </c:if>
            </div>

            <div class="form-group">
              <label for="email">Email Address</label>
              <input type="email" id="email" name="email"
                     value="${form.email}" placeholder="guest@example.com">
              <c:if test="${not empty form.errors['email']}">
                <span class="field-error">${form.errors['email']}</span>
              </c:if>
            </div>

            <div class="form-group">
              <label for="roomType">Room Type *</label>
              <select id="roomType" name="roomType" required>
                <option value="" ${empty form.roomType ? 'selected' : ''}>Select room type</option>
                <option value="Single" data-rate="2200" ${form.roomType == 'Single' ? 'selected' : ''}>Single - LKR 2,200 / night</option>
                <option value="Double" data-rate="3800" ${form.roomType == 'Double' ? 'selected' : ''}>Double - LKR 3,800 / night</option>
                <option value="Deluxe" data-rate="5600" ${form.roomType == 'Deluxe' ? 'selected' : ''}>Deluxe - LKR 5,600 / night</option>
                <option value="Suite" data-rate="8200" ${form.roomType == 'Suite' ? 'selected' : ''}>Suite - LKR 8,200 / night</option>
              </select>
              <c:if test="${not empty form.errors['roomType']}">
                <span class="field-error">${form.errors['roomType']}</span>
              </c:if>
            </div>

            <div class="form-group">
              <label for="rooms">Number of Rooms *</label>
              <input type="number" id="rooms" name="rooms" min="1" max="10"
                     value="${not empty form.rooms ? form.rooms : '1'}" required>
              <c:if test="${not empty form.errors['rooms']}">
                <span class="field-error">${form.errors['rooms']}</span>
              </c:if>
            </div>

            <div class="form-group">
              <label for="checkIn">Check-In Date *</label>
              <input type="date" id="checkIn" name="checkIn" value="${form.checkIn}" required>
              <c:if test="${not empty form.errors['dates']}">
                <span class="field-error">${form.errors['dates']}</span>
              </c:if>
            </div>

            <div class="form-group">
              <label for="checkOut">Check-Out Date *</label>
              <input type="date" id="checkOut" name="checkOut" value="${form.checkOut}" required>
            </div>

            <div class="booking-summary">
              <div>
                <span class="summary-kicker">Amount to pay</span>
                <strong id="totalDue">LKR 0.00</strong>
                <p id="summaryHint">Select a room type and check-out date to calculate the total.</p>
              </div>
              <div class="summary-breakdown" aria-live="polite">
                <span><b id="summaryRate">LKR 0.00</b><small>Rate per night</small></span>
                <span><b id="summaryNights">0</b><small>Nights</small></span>
                <span><b id="summaryRooms">1</b><small>Room(s)</small></span>
              </div>
              <c:if test="${not empty form.errors['price']}">
                <span class="field-error">${form.errors['price']}</span>
              </c:if>
            </div>

            <c:if test="${mode == 'edit'}">
            <div class="form-group">
              <label for="status">Status</label>
              <select id="status" name="status">
                <option value="Pending" ${form.status == 'Pending' ? 'selected' : ''}>Pending</option>
                <option value="Confirmed" ${form.status == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                <option value="Cancelled" ${form.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                <option value="Checked-Out" ${form.status == 'Checked-Out' ? 'selected' : ''}>Checked-Out</option>
              </select>
            </div>
            </c:if>
            <c:if test="${mode != 'edit'}">
              <input type="hidden" name="status" value="Pending">
            </c:if>

            <div class="form-group full">
              <label for="notes">Notes / Special Requests</label>
              <textarea id="notes" name="notes" placeholder="Any special requests or notes...">${form.notes}</textarea>
            </div>

            <div class="form-actions">
              <a href="${pageContext.request.contextPath}/reservations?action=list"
                 class="btn btn-outline">Cancel</a>
              <button type="submit" class="btn btn-primary">
                ${mode == 'edit' ? 'Save Changes' : 'Add Reservation'}
              </button>
            </div>

          </div>
        </form>
      </div>
    </div>
  </main>

  <script>
    const roomRates = {
      Single: 2200,
      Double: 3800,
      Deluxe: 5600,
      Suite: 8200
    };

    const roomType = document.getElementById('roomType');
    const rooms = document.getElementById('rooms');
    const checkIn = document.getElementById('checkIn');
    const checkOut = document.getElementById('checkOut');
    const price = document.getElementById('price');
    const totalDue = document.getElementById('totalDue');
    const summaryHint = document.getElementById('summaryHint');
    const summaryRate = document.getElementById('summaryRate');
    const summaryNights = document.getElementById('summaryNights');
    const summaryRooms = document.getElementById('summaryRooms');
    const bookingSummary = document.querySelector('.booking-summary');
    const isEditMode = '${mode}' === 'edit';

    const money = new Intl.NumberFormat('en-LK', {
      style: 'currency',
      currency: 'LKR',
      minimumFractionDigits: 2
    });

    function parseDate(value) {
      return value ? new Date(value + 'T00:00:00') : null;
    }

    function getNights() {
      const start = parseDate(checkIn.value);
      const end = parseDate(checkOut.value);
      if (!start || !end) return 0;
      return Math.round((end - start) / 86400000);
    }

    function setCheckoutMinimum() {
      if (!checkIn.value) return;
      const minDate = parseDate(checkIn.value);
      minDate.setDate(minDate.getDate() + 1);
      checkOut.min = minDate.toISOString().slice(0, 10);
      if (checkOut.value && checkOut.value < checkOut.min) {
        checkOut.value = '';
      }
    }

    function updatePrice() {
      setCheckoutMinimum();

      const selectedRoom = roomType.value;
      const rate = roomRates[selectedRoom] || 0;
      const roomCount = Math.max(parseInt(rooms.value || '1', 10), 1);
      const nights = getNights();
      const total = rate * roomCount * Math.max(nights, 0);

      summaryRate.textContent = money.format(rate);
      summaryNights.textContent = Math.max(nights, 0);
      summaryRooms.textContent = roomCount;

      if (rate > 0 && nights > 0) {
        price.value = total.toFixed(2);
        totalDue.textContent = money.format(total);
        summaryHint.textContent = selectedRoom + ' room for ' + nights + ' night' + (nights === 1 ? '' : 's') + '.';
        bookingSummary.classList.add('is-ready');
      } else {
        price.value = '';
        totalDue.textContent = money.format(0);
        summaryHint.textContent = 'Select a room type and check-out date to calculate the total.';
        bookingSummary.classList.remove('is-ready');
      }
    }

    [roomType, rooms, checkIn, checkOut].forEach(function(field) {
      field.addEventListener('input', updatePrice);
      field.addEventListener('change', updatePrice);
    });

    if (!isEditMode) {
      checkIn.min = new Date().toISOString().slice(0, 10);
    }
    updatePrice();
  </script>
</body>
</html>
