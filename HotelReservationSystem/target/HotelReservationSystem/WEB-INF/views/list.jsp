<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Reservations - Hotel Reservation System</title>
  <meta name="description" content="View and manage hotel reservations sorted by closest check-in date.">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
  <c:set var="currentPage" value="list"/>
  <%@ include file="nav.jsp" %>

  <main class="main-content">
    <section class="hero-panel compact-hero">
      <div>
        <p class="hero-kicker">Reservation desk</p>
        <h1>Manage upcoming stays</h1>
        <p>Reservations are sorted by the closest upcoming check-in date first.</p>
      </div>
      <a href="${pageContext.request.contextPath}/reservations?action=add" class="btn btn-primary">New Reservation</a>
    </section>

    <section class="page fade-in">
      <c:if test="${param.msg == 'added'}">
        <div class="alert alert-success">Reservation added successfully.</div>
      </c:if>
      <c:if test="${param.msg == 'updated'}">
        <div class="alert alert-success">Reservation updated successfully.</div>
      </c:if>
      <c:if test="${param.msg == 'deleted'}">
        <div class="alert alert-danger">Reservation deleted.</div>
      </c:if>

      <div class="booking-search-card">
        <div class="search-cell">
          <span>Where</span>
          <strong>Hotel Reserve</strong>
        </div>
        <div class="search-cell">
          <span>Order</span>
          <strong>Closest check-in first</strong>
        </div>
        <div class="search-cell">
          <span>Total</span>
          <strong>${fn:length(reservations)} reservation(s)</strong>
        </div>
        <a href="${pageContext.request.contextPath}/reservations?action=search" class="btn btn-primary">Filter</a>
      </div>

      <div class="section-heading">
        <div>
          <h2>All reservations</h2>
          <p>Nearest check-ins are placed at the front of the list.</p>
        </div>
      </div>

      <c:choose>
        <c:when test="${empty reservations}">
          <div class="empty-state card">
            <div class="empty-icon">No stays</div>
            <p>No reservations found. <a href="${pageContext.request.contextPath}/reservations?action=add">Create one</a>.</p>
          </div>
        </c:when>
        <c:otherwise>
          <div class="card reservation-table-card">
            <div class="table-wrap">
              <table class="reservation-table">
                <thead>
                  <tr>
                    <th>Check-In</th>
                    <th>Guest</th>
                    <th>Contact</th>
                    <th>Room</th>
                    <th>Rooms</th>
                    <th>Check-Out</th>
                    <th>Nights</th>
                    <th>Status</th>
                    <th>Total</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="r" items="${reservations}">
                    <c:set var="badgeClass" value="${fn:replace(fn:toLowerCase(r.status),' ','')}"/>
                    <tr>
                      <td class="date-cell">
                        <strong>${r.checkIn}</strong>
                        <span>#${r.id}</span>
                      </td>
                      <td>
                        <span class="guest-name">${r.guestName}</span>
                      </td>
                      <td class="contact-cell">
                        <span>${r.phone}</span>
                        <small><c:out value="${empty r.email ? 'No email' : r.email}"/></small>
                      </td>
                      <td><span class="chip">${r.roomType}</span></td>
                      <td>${r.rooms}</td>
                      <td>${r.checkOut}</td>
                      <td>${r.nights}</td>
                      <td><span class="badge badge-${badgeClass}">${r.status}</span></td>
                      <td class="money-cell">LKR <fmt:formatNumber value="${r.price}" pattern="#,##0.00"/></td>
                      <td>
                        <div class="table-actions">
                          <a href="${pageContext.request.contextPath}/reservations?action=edit&id=${r.id}"
                             class="btn btn-outline btn-sm">Edit</a>
                          <a href="${pageContext.request.contextPath}/reservations?action=delete&id=${r.id}"
                             class="btn btn-danger btn-sm"
                             onclick="return confirm('Delete reservation for ${r.guestName}?')">Delete</a>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>
          </div>
        </c:otherwise>
      </c:choose>
    </section>
  </main>
</body>
</html>
