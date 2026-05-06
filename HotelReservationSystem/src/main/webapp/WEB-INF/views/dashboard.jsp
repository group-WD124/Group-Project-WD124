<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard - Hotel Reservation System</title>
  <meta name="description" content="Hotel Reservation System dashboard with key metrics and upcoming check-ins.">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
  <c:set var="currentPage" value="dashboard"/>
  <%@ include file="nav.jsp" %>

  <main class="main-content">
    <section class="hero-panel">
      <div>
        <p class="hero-kicker">Hotel management</p>
        <h1>Find and manage every stay</h1>
        <p>Track reservations, check-ins, guest details, and revenue from one clean desk.</p>
      </div>
      <div class="hero-actions">
        <a href="${pageContext.request.contextPath}/reservations?action=add" class="btn btn-primary">New Reservation</a>
        <a href="${pageContext.request.contextPath}/reservations?action=search" class="btn btn-light">Search</a>
      </div>
    </section>

    <section class="page fade-in">
      <c:if test="${not empty dbError}">
        <div class="alert alert-danger">Database error: ${dbError}</div>
      </c:if>

      <div class="stats-grid">
        <div class="stat-card" style="--card-accent:#006ce4">
          <div class="stat-icon">All</div>
          <div class="stat-value">${totalCount}</div>
          <div class="stat-label">Total Reservations</div>
        </div>
        <div class="stat-card" style="--card-accent:#febb02">
          <div class="stat-icon">Now</div>
          <div class="stat-value">${pendingCount}</div>
          <div class="stat-label">Pending</div>
        </div>
        <div class="stat-card" style="--card-accent:#008234">
          <div class="stat-icon">OK</div>
          <div class="stat-value">${confirmedCount}</div>
          <div class="stat-label">Confirmed</div>
        </div>
        <div class="stat-card" style="--card-accent:#d4111e">
          <div class="stat-icon">Stop</div>
          <div class="stat-value">${cancelledCount}</div>
          <div class="stat-label">Cancelled</div>
        </div>
        <div class="stat-card" style="--card-accent:#6b5cff">
          <div class="stat-icon">Out</div>
          <div class="stat-value">${checkedOutCount}</div>
          <div class="stat-label">Checked-Out</div>
        </div>
        <div class="stat-card" style="--card-accent:#008234">
          <div class="stat-icon">LKR</div>
          <div class="stat-value"><fmt:formatNumber value="${totalRevenue}" pattern="#,##0"/></div>
          <div class="stat-label">Total Revenue</div>
        </div>
      </div>

      <div class="section-heading">
        <div>
          <h2>Closest check-ins</h2>
          <p>The next reservations that need attention.</p>
        </div>
        <a href="${pageContext.request.contextPath}/reservations?action=list" class="btn btn-outline btn-sm">View all</a>
      </div>

      <div class="property-strip">
        <div class="property-tile tile-blue">
          <span>Today</span>
          <strong>Review arrivals</strong>
          <small>Keep rooms ready before guests arrive.</small>
        </div>
        <div class="property-tile tile-gold">
          <span>Rooms</span>
          <strong>Premium stays</strong>
          <small>Suites, deluxe rooms, and family bookings.</small>
        </div>
        <div class="property-tile tile-green">
          <span>Guests</span>
          <strong>Personal details</strong>
          <small>Contact information and reservation notes.</small>
        </div>
      </div>

      <div class="card">
        <div class="card-header">
          <div>
            <div class="card-title">Upcoming reservation list</div>
            <div class="card-subtitle">Sorted by closest check-in date</div>
          </div>
        </div>

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
                <c:when test="${empty recentList}">
                  <tr><td colspan="8">
                    <div class="empty-state">
                      <div class="empty-icon">No stays</div>
                      <p>No reservations yet. <a href="${pageContext.request.contextPath}/reservations?action=add">Add one</a>.</p>
                    </div>
                  </td></tr>
                </c:when>
                <c:otherwise>
                  <c:forEach var="r" items="${recentList}" end="9">
                    <c:set var="badgeClass" value="${fn:replace(fn:toLowerCase(r.status),' ','')}"/>
                    <tr>
                      <td>${r.id}</td>
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
                        <a href="${pageContext.request.contextPath}/reservations?action=edit&id=${r.id}"
                           class="btn btn-outline btn-sm">Edit</a>
                      </td>
                    </tr>
                  </c:forEach>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>
      </div>
    </section>
  </main>
</body>
</html>
