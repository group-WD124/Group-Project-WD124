<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Search Reservations - Hotel Reservation System</title>
  <meta name="description" content="Search and filter hotel reservations by guest, room, status, or date range.">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
  <c:set var="currentPage" value="search"/>
  <%@ include file="nav.jsp" %>

  <main class="main-content">
    <section class="hero-panel compact-hero">
      <div>
        <p class="hero-kicker">Search desk</p>
        <h1>Find a reservation</h1>
        <p>Filter by guest details, room type, stay status, or date range.</p>
      </div>
      <a href="${pageContext.request.contextPath}/reservations?action=add" class="btn btn-primary">New Reservation</a>
    </section>

    <section class="page fade-in">
      <div class="booking-search-card filter-card">
        <form action="${pageContext.request.contextPath}/reservations" method="get">
          <input type="hidden" name="action" value="search">
          <div class="search-bar">
            <div class="form-group">
              <label for="keyword">Guest / Phone / Email</label>
              <input type="text" id="keyword" name="keyword" value="${keyword}"
                     placeholder="Search by name, phone, email">
            </div>
            <div class="form-group">
              <label for="roomType">Room Type</label>
              <select id="roomType" name="roomType">
                <option value="All" ${roomType == 'All' || empty roomType ? 'selected' : ''}>All Types</option>
                <option value="Single" ${roomType == 'Single' ? 'selected' : ''}>Single</option>
                <option value="Double" ${roomType == 'Double' ? 'selected' : ''}>Double</option>
                <option value="Suite" ${roomType == 'Suite' ? 'selected' : ''}>Suite</option>
                <option value="Deluxe" ${roomType == 'Deluxe' ? 'selected' : ''}>Deluxe</option>
              </select>
            </div>
            <div class="form-group">
              <label for="status">Status</label>
              <select id="status" name="status">
                <option value="All" ${status == 'All' || empty status ? 'selected' : ''}>All Statuses</option>
                <option value="Pending" ${status == 'Pending' ? 'selected' : ''}>Pending</option>
                <option value="Confirmed" ${status == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                <option value="Cancelled" ${status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                <option value="Checked-Out" ${status == 'Checked-Out' ? 'selected' : ''}>Checked-Out</option>
              </select>
            </div>
            <div class="form-group">
              <label for="fromDate">Check-In From</label>
              <input type="date" id="fromDate" name="fromDate" value="${fromDate}">
            </div>
            <div class="form-group">
              <label for="toDate">Check-Out To</label>
              <input type="date" id="toDate" name="toDate" value="${toDate}">
            </div>
            <div class="search-actions">
              <button type="submit" class="btn btn-primary">Search</button>
              <a href="${pageContext.request.contextPath}/reservations?action=search" class="btn btn-outline">Clear</a>
            </div>
          </div>
        </form>
      </div>

      <c:if test="${reservations != null}">
        <div class="section-heading">
          <div>
            <h2>Results</h2>
            <p>${fn:length(reservations)} reservation(s), sorted by closest check-in date.</p>
          </div>
        </div>

        <div class="card">
          <div class="table-wrap">
            <table>
              <thead>
                <tr>
                  <th>#</th>
                  <th>Guest</th>
                  <th>Room</th>
                  <th>Check-In</th>
                  <th>Check-Out</th>
                  <th>Status</th>
                  <th>Price</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <c:choose>
                  <c:when test="${empty reservations}">
                    <tr><td colspan="8">
                      <div class="empty-state">
                        <div class="empty-icon">No match</div>
                        <p>No reservations match your search criteria.</p>
                      </div>
                    </td></tr>
                  </c:when>
                  <c:otherwise>
                    <c:forEach var="r" items="${reservations}">
                      <c:set var="badgeClass" value="${fn:replace(fn:toLowerCase(r.status),' ','')}"/>
                      <tr>
                        <td>#${r.id}</td>
                        <td>
                          <span class="guest-name">${r.guestName}</span><br>
                          <small>${r.phone}</small>
                        </td>
                        <td><span class="chip">${r.roomType}</span></td>
                        <td>${r.checkIn}</td>
                        <td>${r.checkOut}</td>
                        <td><span class="badge badge-${badgeClass}">${r.status}</span></td>
                        <td>LKR <fmt:formatNumber value="${r.price}" pattern="#,##0.00"/></td>
                        <td>
                          <div class="action-btns">
                            <a href="${pageContext.request.contextPath}/reservations?action=edit&id=${r.id}"
                               class="btn btn-outline btn-sm">Edit</a>
                            <a href="${pageContext.request.contextPath}/reservations?action=delete&id=${r.id}"
                               class="btn btn-danger btn-sm"
                               onclick="return confirm('Delete this reservation?')">Delete</a>
                          </div>
                        </td>
                      </tr>
                    </c:forEach>
                  </c:otherwise>
                </c:choose>
              </tbody>
            </table>
          </div>
        </div>
      </c:if>
    </section>
  </main>
</body>
</html>
