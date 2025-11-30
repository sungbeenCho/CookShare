package dto;

import java.util.Date;

public class Recipe {
    private int recipeId;
    private String memberId;
    private String title;
    private String ingredients;
    private String steps;
    private String category;
    private String level;
    private int cookTime;
    private String image;
    private int likesCount;
    private Date regDate;

    public Recipe() {}

    // getter / setter
    public int getRecipeId() { return recipeId; }
    public void setRecipeId(int recipeId) { this.recipeId = recipeId; }

    public String getMemberId() { return memberId; }
    public void setMemberId(String memberId) { this.memberId = memberId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getIngredients() { return ingredients; }
    public void setIngredients(String ingredients) { this.ingredients = ingredients; }

    public String getSteps() { return steps; }
    public void setSteps(String steps) { this.steps = steps; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getLevel() { return level; }
    public void setLevel(String level) { this.level = level; }

    public int getCookTime() { return cookTime; }
    public void setCookTime(int cookTime) { this.cookTime = cookTime; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public int getLikesCount() { return likesCount; }
    public void setLikesCount(int likesCount) { this.likesCount = likesCount; }

    public Date getRegDate() { return regDate; }
    public void setRegDate(Date regDate) { this.regDate = regDate; }
    public String getCookTimeText() {
        switch (cookTime) {
            case 20: return "30분 미만";
            case 45: return "30분~1시간";
            case 90: return "1~2시간";
            case 150: return "2시간 이상";
        }
        return cookTime + "분";
    }

}
