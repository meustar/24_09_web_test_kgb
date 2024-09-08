package com.example.demo.controller;

import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.service.ArticleService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Article;
import com.example.demo.vo.ResultData;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class UsrArticleController {

    @Autowired
    private ArticleService articleService;

    @RequestMapping("/usr/article/detail")
    public String showDetail(Model model, int id) {
        Article article = articleService.getForPrintArticle(id);

        if (article == null) {
            return Ut.jsHistoryBack("F-1", Ut.f("%d번 게시글은 없습니다", id));
        }

        model.addAttribute("article", article);
        return "usr/article/detail";
    }

    @RequestMapping("/usr/article/modify")
    public String showModify(Model model, int id) {
        Article article = articleService.getForPrintArticle(id);

        if (article == null) {
            return Ut.jsHistoryBack("F-1", Ut.f("%d번 게시글은 없습니다", id));
        }

        model.addAttribute("article", article);
        return "/usr/article/modify";
    }

    @RequestMapping("/usr/article/doModify")
    @ResponseBody
    public String doModify(int id, String title, String body) {
        Article article = articleService.getArticleById(id);

        if (article == null) {
            return Ut.jsHistoryBack("F-1", Ut.f("%d번 게시글은 없습니다", id));
        }

        articleService.modifyArticle(id, title, body);
        return Ut.jsReplace("S-1", "게시물이 수정되었습니다.", "../article/detail?id=" + id);
    }

    @RequestMapping("/usr/article/doDelete")
    @ResponseBody
    public String doDelete(int id) {
        Article article = articleService.getArticleById(id);

        if (article == null) {
            return Ut.jsHistoryBack("F-1", Ut.f("%d번 게시글은 없습니다", id));
        }

        articleService.deleteArticle(id);
        return Ut.jsReplace("S-1", "게시물이 삭제되었습니다.", "../article/list");
    }

    @RequestMapping("/usr/article/write")
    public String showWrite(Model model) {
        return "usr/article/write";
    }

    @RequestMapping("/usr/article/doWrite")
    @ResponseBody
    public String doWrite(String title, String body) {
        if (Ut.isEmptyOrNull(title)) {
            return Ut.jsHistoryBack("F-1", "제목을 입력해주세요.");
        }

        if (Ut.isEmptyOrNull(body)) {
            return Ut.jsHistoryBack("F-2", "내용을 입력해주세요.");
        }

        ResultData writeArticleRd = articleService.writeArticle(title, body);
        int id = (int) writeArticleRd.getData1();

        return Ut.jsReplace("S-1", "게시물이 작성되었습니다.", "../article/detail?id=" + id);
    }

    @RequestMapping("/usr/article/list")
    public String showList(Model model, @RequestParam(defaultValue = "1") int page,
                           @RequestParam(defaultValue = "title,body") String searchKeywordTypeCode,
                           @RequestParam(defaultValue = "") String searchKeyword) throws IOException {

        int itemsInAPage = 10;
        List<Article> articles = articleService.getForPrintArticles(itemsInAPage, page, searchKeywordTypeCode, searchKeyword);

        model.addAttribute("articles", articles);
        model.addAttribute("page", page);
        model.addAttribute("searchKeywordTypeCode", searchKeywordTypeCode);
        model.addAttribute("searchKeyword", searchKeyword);

        return "usr/article/list";
    }
}
