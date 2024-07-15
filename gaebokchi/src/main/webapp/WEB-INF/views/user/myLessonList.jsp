<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>회원정보｜GOLFRO</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <c:url var="css" value="/css/my_lesson_list.css" />
    <link rel="stylesheet" type="text/css" href="${css}">
</head>
<body>
    <header>
        <%@ include file="../fragments/header.jspf"%>
    </header>

    <div class="container">
        <div class="row">
            <%@ include file="../fragments/menu.jspf"%>

            <div class="col-8">
                <!-- 인기 게시물 리스트업부 -->
                <div class="card border-0">
                    <div class="card-header">
                        <c:url var="mainPostSearch" value="/mainPost/search" />
                        <form method="get" action="${mainPostSearch}">
                            <input type="hidden" name="userid" value="${userid}" />

                            <!-- 검색 전채 영역 -->
                            <div class="row searchArea d-flex">

                                <!-- 전체 목록 보기 버튼 -->
                                <div class="col-auto">
                                    <button type="button" class="form-control" id="btnAllRead" onclick="location.href='list'">전체글 목록</button>
                                </div>

                                <!-- select 태그 영역(카테고리 선택) -->
                                <div class="col d-flex justify-content-center align-items-center flex-grow-1">
                                    <div class="row w-100 justify-content-center align-items-center">
                                        <div class="col-2 ">
                                            <select class="form-control" name="searchCategory" id="searchCategory" onchange="toggleSearchField()">
                                                <option value="searchClubs">클럽별 검색</option>
                                                <option value="searchSelection">채택별 검색</option>
                                                <option value="searchTitle">제목 검색</option>
                                                <option value="searchContent">내용 검색</option>
                                                <option value="searchTitleContent">제목+내용 검색</option>
                                                <option value="searchAuthor">작성자 검색</option>
                                            </select>
                                        </div>
                                        <!-- 동적 요소를 포함할 컨테이너 -->
                                        <div class="col-4">
                                            <!-- 초기값으로 클럽 선택 콤보박스 표시 -->
                                            <div id="clubSelectField">
                                                <select class="form-control" name="clubSelect" id="clubSelect">
                                                    <c:forEach items="${clubs}" var="c">
                                                        <option value="${c.id}">${c.name}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>

                                            <!-- 초기값으로 입력 필드는 숨김 -->
                                            <div id="textSearchSelectField" style="display: none;">
                                                <input type="text" class="form-control" name="textSearchSelect" placeholder="검색어를 입력하세요">
                                            </div>

                                            <div id="searchSelectionField" style="display: none;">
                                                <select class="form-control" name="selectSelection" id="selectSelection">
                                                    <option value="selectFalse">미완료</option>
                                                    <option value="selectTrue">해결완료</option>
                                                </select>
                                            </div>
                                        </div>

                                        <!-- 검색 버튼 영역 -->
                                        <div class="col-auto">
                                            <input type="submit" class="form-control" value="검색" id="searchButton" />
                                        </div>
                                    </div>

                                </div>

                                <!-- 글 작성하기 버튼 -->
                                <c:if test="${signedInUserGrade eq 'G21' || signedInUserGrade eq 'G22' || signedInUserGrade eq 'G23' || signedInUserGrade eq 'G24' || signedInUserGrade eq 'G01' }">
                                    <div class="col-auto">
                                        <button type="button" class="form-control" id="btnCreateMainPost" onclick="location.href='create'">글쓰기⮟</button>
                                    </div>
                                </c:if>
                            </div>
                        </form>
                    </div>

                    <div class="card-body mb-1">
                        <!-- 메인 게시판 목록 영역 -->
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th class="col-1">클럽종류</th>
                                    <th class="col-4">제목</th>
                                    <th class="col-2">작성자</th>
                                    <th class="col-1">조회</th>
                                    <th class="col-1">좋아요</th>
                                    <th class="col-2">작성일</th>
                                    <th class="col-1">채택</th>
                                </tr>
                            </thead>
                            
                            <!-- 메인 게시판 목록 생성 영역 -->
                            <tbody>
                                <c:forEach var="p" items="${post}">
                                    <tr>
                                        <td class="text-center" id="club">${p.clubType}</td>
                                        <td id="post">
                                            <c:url var="mainPostDetailsPage" value="/mainPost/details">
                                                <c:param name="id" value="${p.id}" />
                                            </c:url> <a href="${mainPostDetailsPage}">${p.title}</a>
                                        </td>
                                        <td id="author">${p.author}</td>
                                        <td class="text-center">${p.views}</td>
                                        <td class="text-center">${p.likes}</td>
                                        <td class="text-center">${p.createdTime}</td>
                                        <td class="text-center">${p.selection}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>

                        <!-- 페이징 UI 추가 -->
                        <nav aria-label="Page navigation">
                            <ul class="pagination justify-content-center">
                                <c:choose>
                                    <c:when test="${currentPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${currentPage - 1}&size=${pageSize}" aria-label="Previous">
                                                <span aria-hidden="true">&laquo;</span>
                                            </a>
                                        </li>
                                    </c:when>
                                    <c:otherwise>
                                        <li class="page-item disabled">
                                            <a class="page-link" href="#" aria-label="Previous">
                                            	<span aria-hidden="true">&laquo;</span>
                                            </a>
                                        </li>
                                    </c:otherwise>
                                </c:choose>
                                <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="?page=${i}&size=${pageSize}">${i}</a>
                                    </li>
                                </c:forEach>
                                <c:choose>
                                    <c:when
                                        test="${currentPage < totalPages}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${currentPage + 1}&size=${pageSize}" aria-label="Next">
                                                <span aria-hidden="true">&raquo;</span>
                                            </a>
                                        </li>
                                    </c:when>
                                    <c:otherwise>
                                        <li class="page-item disabled">
                                            <a class="page-link" href="#" aria-label="Next">
                                                <span aria-hidden="true">&raquo;</span>
                                            </a>
                                        </li>
                                    </c:otherwise>
                                </c:choose>
                            </ul>
                        </nav>
                        
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script
	   src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
	   integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
	   crossorigin="anonymous"></script>
    
       <c:url var="listJS" value="/js/list.js" />
       <script src="${ listJS }"></script>
    
    <script type="text/javascript">
		searchButton
    
		function toggleSearchField() {
			var searchCategory = document.getElementById("searchCategory").value;
     		var clubSelectField = document.getElementById("clubSelectField");
      		var textSearchSelectField = document.getElementById("textSearchSelectField");
       		var searchSelectionField = document.getElementById("searchSelectionField");
    
          	if (searchCategory === "searchClubs") {
          		clubSelectField.style.display = "block";
                textSearchSelectField.style.display = "none";
                searchSelectionField.style.display = "none";
      		} else if (searchCategory === "searchSelection") {
      			clubSelectField.style.display = "none";
                textSearchSelectField.style.display = "none";
                searchSelectionField.style.display = "block";
       		} else {
                clubSelectField.style.display = "none";
                textSearchSelectField.style.display = "block";
                searchSelectionField.style.display = "none";
    		}
   		}
	</script>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>